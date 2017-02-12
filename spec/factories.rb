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
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'lenna.jpg'), 'image/jpg') }

    association :user
  end
end
