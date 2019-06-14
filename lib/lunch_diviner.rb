# frozen_string_literal: true
require_relative './reishauer_diviner'
require_relative './siemens_diviner'
require_relative './andulino_diviner'


class LunchDiviner
  def initialize(format = :slack)
    @format = format
  end

  def slack_formatted_menu(day = Date.today.wday)
    titles = ['REISHAUER', 'SIEMENS MENSA', 'ANDULINO']
    menus = [ReishauerDiviner, SiemensDiviner, AndulinoDiviner].map { |clazz| clazz.new.slack_formatted_menu }

    titles.zip(menus).map { |title, menu| "```#{title}```\n#{menu}" }.join("\n\n")
  end
end
