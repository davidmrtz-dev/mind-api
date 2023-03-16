return unless Rails.env.development? || Rails.env.staging?

account = Account.create!(
  client_name: 'Homero Simpson',
  manager_name: 'Steve Jobs',
  name: 'Bussiness Account'
)

3.times.each do |num|
  User.create!(
    name: Faker::Name.first_name,
    email: "user-#{num}@example.com",
    password: 'password'
  )
end

3.times do
  Team.create!(
    account: account,
    name: Faker::Team.state
  )
end

Team.all.each do |team|
  User.first(2).each do |user|\
    UserTeam.create!(
      team: team,
      user: user,
      start_at: Time.zone.today,
      end_at: Time.zone.tomorrow,
      status: :active
    )
  end
end

UserTeam.create!(team: Team.last, user: User.last, status: :active)
User.create!(
  email: 'user@example.com',
  name: 'David Mtz',
  password: 'password',
  user_type: :admin
)

User.all.each do |user|
  Profile.create!(
    user: user,
    english_level: ['a1', 'a2', 'b1', 'b2', 'c1', 'c2'].sample,
    technical_knowledge: ['Docker', 'AWS', 'Azure', 'Cloud'].sample,
    cv: 'https://mycv.com'
  )
end
