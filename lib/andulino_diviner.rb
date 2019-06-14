# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'

class AndulinoDiviner
  def initialize(format = :slack)
    @format = format
    @parsed_html = Nokogiri::HTML(html_menu_content)
  end

  def menu_image_url
    @parsed_html.css('#primary img').attr('src').value
  end

  def slack_formatted_menu(day = Date.today.wday)
    menu_image_url
  end

  def html_formatted_menu(day = Date.today.wday)
    "<img src='#{menu_image_url}' />"
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

  def html_menu_content
    open(ENV['ANDULINO_MENU_URL'])
  end
end
