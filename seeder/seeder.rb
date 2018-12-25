require 'csv'
rows = CSV.read('input/parts_numbers.csv')

input_headers = rows[0]

rows.each_with_index do |row, index|

  if index>0
    product_input_details = Hash[input_headers.zip row]
    part_number =row[1]
    pages << {
        page_type: 'part_number_search',
        method: 'GET',
        url: "https://www.mouser.com/_/?Keyword=#{part_number}",
        vars: {'product_input_details' => product_input_details}


    }
  end
end


