# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'

class LunchDiviner
  MENU = 0
  VEGETARIAN = 1
  DAILY_SPECIAL = 2

  def initialize(format = :slack)
    @format = format
    @parsed_html = Nokogiri::HTML(html_menu_content)
  end

  def meal(menu_type, day)
    meal_node = menu_type(menu_type).css('.meal').at(day).children
    meal_object(meal_node)
  end

  def menu(day = Date.today.wday)
    return 'Weekday not between monday and friday' unless day.between?(1, 5)
    [meal(LunchDiviner::MENU, day),
     meal(LunchDiviner::VEGETARIAN, day),
     meal(LunchDiviner::DAILY_SPECIAL, day)]
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
    { title: meal_node.css('h3').text,
      price: meal_node.css('dd.price').text.gsub(/CHF[^\d]*(.*)/, '\1'),
      description: meal_node.css('div.meal-description').text.strip }
  end

  def menu_type(type)
    @parsed_html.css('.menu-section').at(type).children
  end

  def html_menu_content
    page_url = 'https://clients.eurest.ch/de/reishauer/wallisellen/menu'
    open(page_url)
  end
end
