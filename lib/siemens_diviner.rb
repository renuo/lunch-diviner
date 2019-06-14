# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'

class SiemensDiviner
  CHEFS_CHOICE = 0
  SEASON_MARKET = 1
  FREE_CHOICE = 2
  DAILYS = 3
  PASTA_PIZZA = 4

  def initialize(format = :slack)
    @format = format
    @parsed_html = Nokogiri::HTML(html_menu_content)
  end

  def meal(menu_type)
    menu_node = @parsed_html.css('#menu-plan-tab1 .menu-item').at(menu_type)
    meal_object(menu_node.css('.item-content'))
  rescue
    nil
  end

  def menu(day = Date.today.wday)
    return 'Weekday not between monday and friday' unless day.between?(1, 5)
    [meal(SiemensDiviner::CHEFS_CHOICE),
     meal(SiemensDiviner::SEASON_MARKET),
     meal(SiemensDiviner::FREE_CHOICE),
     meal(SiemensDiviner::DAILYS)
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
    { title: meal_node.css('h2').text,
      price: meal_node.css('.menu-prices .val').text.strip,
      description: meal_node.css('.menu-description').text.split("\n").map { |d| d.strip }.join(' ').strip }
  end

  def menu_type(type)
    @parsed_html.css('.menu-section').at(type).children
  end

  def html_menu_content
    open(ENV['SIEMENS_MENU_URL'])
  end
end
