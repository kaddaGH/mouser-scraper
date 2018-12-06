html = Nokogiri.HTML(content)
product_details = {
    _collection: 'products',
    "ProductName" => html.css('span.bc-no-link')&.text,
    "ProductDescription" => html.css('span#spnDescription')&.text&.strip,
    "price" => content.match(/"Qty":1,"FormattedUnitPrice":"([^"]+?)"/) ? content.scan(/"Qty":1,"FormattedUnitPrice":"([^"]+?)"/)[0][0] : ""
}
# Extract extra details for the  product
content.scan(/"Label":"([^"]+?):".+?"Value":"([^"]+?)"/).each do |specification|

  product_details[specification[0].sub(/[^A-Za-z]/, '')] = specification[1]

end
outputs << product_details