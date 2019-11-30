FactoryBot.define do
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

    refcode
  end

  factory :comment do
    association :user
    association :story
    
    comment { "This is great" }
  end
end