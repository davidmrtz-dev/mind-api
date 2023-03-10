return unless Rails.env.development? || Rails.env.staging?

account = Account.create!(
  client_name: 'Homero Simpson',
  manager_name: 'Steve Jobs',
  name: 'Bussiness Account'
)

3.times.each do |num|
  User.create!(
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
      status: :active
    )
  end
end

UserTeam.create!(team: Team.last, user: User.last, status: :active)
