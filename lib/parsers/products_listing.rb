class ParserProductsList
  attr_reader :content, :vars, :outputs, :pages, :page, :nokogiri

  def initialize(params = {})
    @content = params[:content]
    @vars = params[:vars] || {}
    @outputs = params[:outputs]
    @pages = params[:pages]
    @page = params[:page]
    @nokogiri = Nokogiri.HTML(content)
  end

  def parse
    part_number = result.at_css('.tr-dkPartNumber a')
    url = part_number.attribute('href').value
    vars[:part_number] = part_number.text.strip || vars[:part_number]
    pages << new_search_page(url)
    add_listing_pages

  end

  def add_listing_pages
    next_page = nokogiri.at_css('.Next')

    if next_page
      url = next_page.attribute('href').value

      pages << new_search_page(url)
    end
  end

  def new_search_page(url)

    {
        vars: vars,
        url: ROOT_URL + url,
        page_type: 'name_search',

    }
  end


end
