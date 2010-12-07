xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Six Minute Story: Top rated stories"
    xml.description "Top rated stories on http://sixminutestory.com" 
    xml.link top_url(:format => :rss)
    
    for story in @stories do
      xml.item do
        xml.title story.title
        xml.author story.user.id
        xml.description simple_format(h(story.description))
        xml.pubDate story.created_at.rfc822
        xml.link story_url(story)
      end
    end
  end
end
