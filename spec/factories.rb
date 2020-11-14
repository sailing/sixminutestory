FactoryBot.define do
  factory :winner do
    contest { nil }
    story { nil }
    user { nil }
    winner_type { "MyString" }
  end

  factory :contest do
    association :user, :admin
    association :prompt

    title { "MyText" }
    description { "MyText" }
    allow_multiple_entries { false }
    terms { "MyText" }
    starts_at { Time.now.to_date }
    ends_at { 1.week.from_now.to_date }
    approved { false }
  end

  sequence :email do |n|
    "galen#{n}@sixminutestory.com"
  end

  sequence :login do |n|
    "user#{n}"
  end

  sequence :refcode do |n|
     "It was a dark and stormy night #{n}"
  end

  factory :user do
    login
    email
    password { "password" }
    profile { "etc, etc, etc" }
    confirmed_at { 1.day.ago }

    admin_level { 1 }

    trait :admin do
      admin_level { 3 }
    end
  end

  factory :story do
    association :user
    association :prompt

    title { "A Tale of Woe" }
    description { "Once upon a time" }
    license { Story::CC_OPTIONS.first }
  end

  factory :prompt do
    association :user
    kind { "firstline" }
    refcode
  end

  factory :comment do
    association :user
    association :story
    
    comment { "This is great" }
  end
end