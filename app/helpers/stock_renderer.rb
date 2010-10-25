class StockRenderer < WillPaginate::LinkRenderer
  def page_link(page, text, attributes = {})
    @template.link_to text, url_for(page), attributes
  end
end