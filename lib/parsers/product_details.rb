class ParserProductDetails
  attr_reader :content, :vars, :outputs, :pages, :page

  def initialize(params = {})
    @content = params[:content]
    @vars = params[:vars]
    @outputs = params[:outputs]
    @pages = params[:pages]
    @page = params[:page]
  end

  def parse
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

  end
end




