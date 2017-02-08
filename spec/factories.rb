FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "foobar-#{n}@foobar.com"
    end
    password "foobar"
    password_confirmation "foobar"
  end

  factory :gram do
    message "hello"
    association :user
  end
end
