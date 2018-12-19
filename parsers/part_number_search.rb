# Part number search return product details page if one result found or listing of products if there is many matches

html = Nokogiri.HTML(content)

# If it's one product details returned by search
if html.at_css('#product-desc')
  product_details = {
      _collection: 'products',
      #QuantityOnHand
      "Manufacturer" => html.css('#lnkManufacturerName').text.strip,
      "PartNumberWebsite" => html.css('span#spnManufacturerPartNumber').text.strip,
      "QuantityOnHand" => html.at_css('div.col-xs-4:contains("Stock:")').next_element.text.to_i,
      "QuantityOnOrder" => html.at_css('div.col-xs-4:contains("On Order:")').next_element.text.to_i

  }
  min_max_quantity_regex = /<div>Minimum:&nbsp(.+)&nbsp&nbsp&nbspMultiples:&nbsp(.+)</
  min_max_match = content.match(min_max_quantity_regex)
  if min_max_match
    product_details['MinimumOrderQuantity'] = min_max_match[1]
    product_details['StandardPackageQuantity'] = min_max_match[2]

  end
  prices_block = html.at_css('.pdp-pricing-table')
  unless prices_block.nil?
    counter=1
    prices_block.css('.div-table-row')[0..-1].map do |price_info|
      columns = price_info.css('div div')
      product_details['Quantity'+counter.to_s] = columns[1].text.strip
      product_details['Price'+counter.to_s] = columns[2].text.strip
      counter+=1

    end
  end


  outputs << product_details

# If it's listing
elsif html.at_css('.SearchResultsPaging')
  # Extract all products links from page
  content.scan(/'(.+?)' OnClick="/).each do |product_link|

    pages << {
        page_type: 'part_number_search',
        method: 'GET',
        url: "https://www.mouser.com#{product_link[0]}",

    }

  end

  # Add next page
  next_page = html.at_css('#ctl00_ContentMain_PagerBottom_lnkNext')
  if next_page
    next_page_url = next_page.attribute('href').value

    pages << {
        page_type: 'part_number_search',
        method: 'GET',
        url: "https://www.mouser.com#{next_page_url}",

    }

  end


end


