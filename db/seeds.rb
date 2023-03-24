return unless Rails.env.development? || Rails.env.staging?

TECHNOLOGIES = ['Docker', 'AWS', 'Azure', 'React', 'SQL', 'Redux', 'Postgres', '.NET', 'Bash', 'RoR']
ENGLISH_LEVELS = ['a1', 'a2', 'b1', 'b2', 'c1', 'c2']

account = Account.create!(
  client_name: 'Homero Simpson',
  manager_name: 'Steve Jobs',
  name: 'Bussiness Account'
)

3.times.each do |num|
  user = User.create!(
    name: Faker::Name.first_name,
    email: "user-#{num}@example.com",
    password: 'password'
  )
  user.profile.create!(
    english_level: ENGLISH_LEVELS.sample,
    technical_knowledge: TECHNOLOGIES.take(3).join(', '),
    cv: "https://user-#{num}-cv.com"
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

UserTeam.create!(team: Team.last, user: User.last, status: :active, start_at: Time.zone.today, end_at: Time.zone.tomorrow)

User.create!(
  email: 'user@example.com',
  name: 'David Mtz',
  password: 'password',
  user_type: :admin
)
