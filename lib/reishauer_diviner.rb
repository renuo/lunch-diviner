# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'

class ReishauerDiviner
  MENU = 0
  VEGETARIAN = 1
  DAILY_SPECIAL = 2

  def initialize(format = :slack)
    @format = format
    @parsed_html = Nokogiri::HTML(html_menu_content)
  end

  def meal(menu_type, day)
    daily_menues = @parsed_html.css('mat-tab-body.mat-tab-body').at(day - 1)
    menu_node = daily_menues ? daily_menues.css('.list-item').at(menu_type).children : nil
    meal_object(menu_node)
  rescue
    nil
  end

  def menu(day = Date.today.wday)
    return 'Weekday not between monday and friday' unless day.between?(1, 5)
    [meal(ReishauerDiviner::MENU, day),
     meal(ReishauerDiviner::VEGETARIAN, day),
     meal(ReishauerDiviner::DAILY_SPECIAL, day)
    ].compact
  end

  def slack_formatted_menu(day = Date.today.wday)
    menu(day).map { |m| slack_formatted_meal(m) }.join("\n\n")
  end

  def html_formatted_menu(day = Date.today.wday)
    menu(day).map { |m| html_formatted_meal(m) }.join("\n")
  end

  private

  def slack_formatted_meal(m)
    "*#{m[:title]}* (#{m[:price]})\n#{m[:description]}"
  end

  def html_formatted_meal(m)
    "<h3 class=\"title\"><span class=\"menu-name\">#{m[:title]}</span> "\
    "<span class=\"price\">(#{m[:price]})</span></h3>"\
     "<p class=\"description\">#{m[:description]}</p>"
  end

  def meal_object(meal_node)
    { title: css_from_meal_node(meal_node, 'h3'),
      price: css_from_meal_node(meal_node, '.price-wrapper').gsub(',','.').gsub('CHF ',''),
      description: css_from_meal_node(meal_node, 'h3 ~ p') }
  end

  def css_from_meal_node(meal_node, css_selector)
    return '' if meal_node.nil?
    meal_node.css(css_selector).text.strip
  end


  def html_menu_content
    open(ENV['REISHAUER_MENU_URL'])
  end
end
