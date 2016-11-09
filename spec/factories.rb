FactoryGirl.define do
  factory :prompt do
    hero "MyString"
    villain "MyString"
    goal "MyString"
    use_on "2016-11-09"
    rating 1
    counter 1
    user_id 1
    contest_id 1
    active false
    verified false
    delta false
    created_at "2016-11-09 18:11:37"
    updated_at "2016-11-09 18:11:37"
    stories_count 1
    refcode "MyString"
    kind "MyString"
    attribution "MyString"
    attribution_url "MyString"
    license "MyString"
    votes_count 1
    license_url "MyString"
    license_en "MyString"
    license_image_url "MyString"
  end
  factory :story do
    title "MyString"
    description "MyText"
    license "MyString"
    votes_count 1
    comment_counter 1
    flagged 1
    counter 1
    user_id 1
    prompt_id 1
    contest_id 1
    delta false
    active false
    created_at "2016-11-09 17:59:26"
    updated_at "2016-11-09 17:59:26"
    cached_slug "MyString"
    comments_count 1
    featured false
  end
end
