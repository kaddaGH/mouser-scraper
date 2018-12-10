rerequire './lib/parser/products_listing'
require './lib/parser/product_details'
# Part number search return product details page if one result found or listing of products if there is many matches
# This parser act like  controler and call right parser for right page
params = {
    vars: page['vars'],
    content: content,
    outputs: outputs,
    page: page,
    pages: pages
}


nokogiri = Nokogiri.HTML(content)
# if listing page detected
if nokogiri.at_css('#product-desc')
  ParserProductDetails.new(params).parse
# if product details page found
elsif nokogiri.at_css('#ctl00_ContentMain_liProductsTab')
  ParserProductsList.new(params).parse
end




