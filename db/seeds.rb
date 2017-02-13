User.delete_all
Gram.delete_all
Comment.delete_all

############################# Users ####################################

16.times do |n|
  User.create!(
    email:    "foobar-#{n}@foobar.com",
    password: "foobar"
  )
end

user_ids = []
User.find_each { |user| user_ids << user.id }

############################# Grams ####################################

8.times do |n|
  message = Faker::Hipster.paragraph(4, false, 1)
  img_path = "db/seed_data/lenna.jpg"
  user_id = user_ids.sample

  Gram.create!(
    message: message,
    picture: Rails.root.join(img_path).open,
    user_id: user_id
  )
end

gram_ids = []
Gram.find_each { |gram| gram_ids << gram.id }

############################ Comments ##################################

24.times do
  message = Faker::Hipster.paragraph(2, false, 1)
  gram_id = gram_ids.sample
  user_id = user_ids.sample

  Comment.create!(
    message: message,
    gram_id: gram_id,
    user_id: user_id
  )
end
