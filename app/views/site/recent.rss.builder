xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Sharearchy: Recent shares"
    xml.description "Recent Open Art, Tools and Information on sharearchy.com" 
    xml.link formatted_root_url(:rss)
    
    for share in @shares do
      xml.item do
        xml.title "#{share.title}"
        xml.description "#{share.description}"
        xml.pubDate share.created_at.to_s(:rfc822)
        xml.link share_url(share, :html)
      end
    end
  end
end
