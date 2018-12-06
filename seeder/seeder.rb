require 'csv'

codes = CSV.read('input/part_numbers.csv').flatten

codes.each do |code|
  pages << {
      page_type: 'part_number_search',
      method: 'GET',
      url: "https://www.mouser.com/_/?Keyword=#{code}",

  }
end


