FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 8..20) }
    password { "password" }
    name { Faker::Name.name }

    # Ensures `has_secure_password` creates a password digest
    after(:build) { |user| user.password_digest = BCrypt::Password.create(user.password) }
  end
end
