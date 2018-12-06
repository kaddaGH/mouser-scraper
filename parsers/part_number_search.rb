class ParserProductPage
  attr_reader :content, :vars, :outputs, :pages, :page

  def initialize(params = {})
    @content = params[:content]
    @vars = params[:vars]
    @outputs = params[:outputs]
    @pages = params[:pages]
    @page = params[:page]
  end

  def parse
    nokogiri = Nokogiri.HTML(content)

    info_table = nokogiri.css('table#product-overview')

    usd_prices_table = nokogiri.at_css('#priceProcurement .product-dollars')

    product = {}

    product['part_number'] = info_table.at_css('#reportPartNumber').text.strip
    product['quantity'] = info_table.css('#quantityAvailable span').text.strip
    product['description'] = info_table.at("//td[@itemprop = 'description']").text.strip
    product['manufacturer_number'] = info_table.at("//h1[@itemprop = 'model']").text.strip
    product['_collection'] = 'listings'

    unless usd_prices_table.nil?
      product['prices'] = usd_prices_table.css('tr')[1..-1].map do |price_info|
        columns = price_info.css('td')

        {
            'price_break': columns.first.text.strip,
            'unit_price': columns[1].text.strip,
            'expected_price': columns.last.text.strip
        }
      end
    end

    outputs << product
  end
end
