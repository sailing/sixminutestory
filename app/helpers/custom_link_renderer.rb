class CustomLinkRenderer < WillPaginate::LinkRenderer
  def page_link(page, text, attributes = {})
    @template.link_to text, "?#{param_name}=#{page}", attributes
  end
end