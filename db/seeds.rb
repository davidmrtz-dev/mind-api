return unless Rails.env.development? || Rails.env.staging?

account = Account.create!(
  client_name: 'Homero Simpson',
  manager_name: 'Steve Jobs',
  name: 'Bussiness Account'
)

3.times do
  Team.create!(
    account: account,
    name: Faker::Team.state
  )
end

