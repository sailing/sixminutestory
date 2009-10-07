xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Six Minute Story: Top rated stories"
    xml.description "Top rated stories on sixminutestory.com" 
    xml.link formatted_root_url(:rss)
    
    for story in @stories do
      xml.item do
        xml.title "#{story.title}"
        xml.description "#{story.description}"
        xml.pubDate story.created_at.to_s(:rfc822)
        xml.link formatted_story_url(story, :html)
      end
    end
  end
end
