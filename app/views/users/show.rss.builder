xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Six Minute Story: Stories from writers you follow"
    xml.description "Writers you follow on http://sixminutestory.com" 
    xml.link profile_url(@user, :format => :rss)
    
    for story in @stories do
      xml.item do
        xml.title story.title
        xml.author story.user.id
        xml.description simple_format(h(story.description))
        xml.pubDate story.created_at.rfc822
        xml.link read_story_url(story, :format => :html)
      end
    end
  end
end
