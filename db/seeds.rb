return unless Rails.env.development? || Rails.env.staging?

TECHNOLOGIES = ['Docker', 'AWS', 'Azure', 'React', 'SQL', 'Redux', 'Postgres', '.NET', 'Bash', 'RoR']
ENGLISH_LEVELS = ['a1', 'a2', 'b1', 'b2', 'c1', 'c2']

admin = User.create!(
  email: 'admin@example.com',
  name: 'David Mtz',
  password: 'password',
  user_type: :admin
)

admin.create_profile!(
  english_level: 'c2',
  technical_knowledge: TECHNOLOGIES.take(6).join(', '),
  cv: "https://user-admin-cv.com"
)

30.times.each do |num|
  user = User.create!(
    name: Faker::Name.first_name,
    email: "user-#{num}@example.com",
    password: 'password'
  )
  user.create_profile!(
    english_level: ENGLISH_LEVELS.sample,
    technical_knowledge: TECHNOLOGIES.take(3).join(', '),
    cv: "https://user-#{num}-cv.com"
  )
end

5.times do
  Account.create!(
    client_name: Faker::Name.name,
    manager_name: Faker::Name.name,
    name: Faker::Name.male_first_name
  )
end

Account.all.each do |account|
  [1, 2, 3].sample.times do
    Team.create!(
      account: account,
      name: Faker::Team.name
    )
  end
end



# Team.all.each do |team|
#   User.first(2).each do |user|\
#     UserTeam.create!(
#       team: team,
#       user: user,
#       start_at: Time.zone.today,
#       end_at: Time.zone.tomorrow,
#       status: :active
#     )
#   end
# end
