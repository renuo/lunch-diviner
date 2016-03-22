require 'spreadsheet'
require 'open-uri'
require 'httparty'

class LunchDiviner
  BASE_URL = 'http://www.compass-group.ch/units'
  @fields
  @format

  def initialize(format = :slack)
    @fields = map_excel_fields_to_array
    @format = format
  end

  def get_menu(day = Date.today.wday)
    return 'Weekday not between monday and friday' unless day.between?(1,5)
    print_weekday(day)
  end

  private

  def get_excel_file_url
    page_url = "#{BASE_URL}/sites/menu.asp?id=67623317241669"
    excel_file_match = HTTParty.get(page_url).match("<a href=\"\.\.\/pdf\/([0-9]*\.xls)\"")
    fail "Excel path on #{page_url} not found" unless excel_file_match
    fail "Too many links on #{page_url}: #{excel_file_match.inspect}" if excel_file_match.size > 2
    "#{BASE_URL}/pdf/#{excel_file_match[1]}"
  end

  def map_excel_fields_to_array
    sheet1 = Spreadsheet.open(open(get_excel_file_url)).worksheet(0)
    tmp_array = Array.new
    sheet1.each_with_index do |row, index_row|
      tmp_array[index_row] = Array.new
      row.each_with_index do |cell, index_cell|
        tmp_array[index_row][index_cell] = cell
      end
    end
    tmp_array
  end

  def print_menu(rowindex, colindex)
    title = @fields[rowindex+=3][colindex]
    price = @fields[rowindex+6][colindex+1]
    description = "#{@fields[rowindex+=1][colindex]} "\
      "#{@fields[rowindex+=1][colindex]} "\
      "#{@fields[rowindex+=1][colindex]} "\
      "#{@fields[rowindex+=1][colindex]}"
    format_menu(title, price, description)
  end

  def format_menu(title, price, description)
    price.gsub!(/\A[[:space:]]+/, '')
    if @format == :slack
      return "*#{title}* (#{price})\n#{description}\n"
    end

    "<h3 class=\"title\"><span class=\"menu-name\">#{title}</span> <span class=\"price\">(#{price})</span></h3>"\
    "<p class=\"description\">#{description}</p>"
  end

  def print_day(rowindex)
    "#{print_menu(rowindex,1)}\n"\
    "#{print_menu(rowindex,5)}\n"\
    "#{print_menu(rowindex,9)}"\
  end

  def print_weekday(weekday)
    "#{print_day(4+(weekday-1)*11)}"

  end
end
