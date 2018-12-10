# Part number search return product details page if one result found or listing of products if there is many matches

html = Nokogiri.HTML(content)

# If it's one product details returned by search
if html.at_css('#product-desc')
  product_details = {
      _collection: 'products',
      "part_number" => html.css('span#spnMouserPartNumFormattedForProdInfo').text.strip,
      "quantity" => html.css('.pdp-pricing-header').text.sub('In Stock:','').strip,
      "description" => html.css('span#spnDescription').text.strip,
      "manufacturer_number" => html.css('span#spnManufacturerPartNumber').text.strip,

  }
  prices_block = html.at_css('.pdp-pricing-table')
  unless prices_block.nil?
     product_details['prices'] = prices_block.css('.div-table-row')[0..-1].map do |price_info|
      columns = price_info.css('div div')
      {
          'quantity':columns[0].text.strip,
          'unit_price':columns[2].text.strip,
          'ext_price':columns[3].text.strip
      }
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


