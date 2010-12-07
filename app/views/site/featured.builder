xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Six Minute Story: Featured stories"
    xml.description "Featured stories on http://sixminutestory.com" 
    xml.link featured_url(:format => :rss)
    
    for story in @stories do
      xml.item do
        xml.title story.title
        xml.author story.user.login
        xml.description simple_format(h(story.description))
        xml.pubDate story.created_at.rfc822
        xml.link story_url(story)
      end
    end
  end
end
