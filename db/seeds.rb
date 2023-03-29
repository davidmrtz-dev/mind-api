return unless Rails.env.development? || Rails.env.staging?

TECHNOLOGIES = ['Docker', 'AWS', 'Azure', 'React', 'SQL', 'Redux', 'Postgres', '.NET', 'Bash', 'RoR']
ENGLISH_LEVELS = ['a1', 'a2', 'b1', 'b2', 'c1', 'c2']
TODAY = Time.zone.today
FUTURE_DATES = [3.days.from_now, 4.days.from_now, 5.days.from_now, 6.days.from_now]
STATUSES = [:active, :inactive]

spr_user = User.create!(
  email: 'super-user@example.com',
  name: 'David Mtz',
  password: 'password',
  user_type: :super
)

spr_user.create_profile!(
  english_level: 'c2',
  technical_knowledge: TECHNOLOGIES.take(6).join(', '),
  cv: "https://spr-user-cv.com"
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
  [5, 7, 9].sample.times do
    Team.create!(
      account: account,
      name: Faker::Team.name
    )
  end
end

users = User.not_include_super
teams = Team.all

users.each do |user|
  teams.each do |team|
    user_team = UserTeam.new(
      team: team,
      user: user,
      start_at: TODAY,
      end_at: FUTURE_DATES.sample,
      status: STATUSES.sample
    )

    user_team.save if rand < 0.45 && user_team.valid?
  end
end


# 12.times do
#   user_team = UserTeam.new(
#     team: Team.all.sample,
#     user: user,
#     start_at: TODAY,
#     end_at: FUTURE_DATES.sample,
#     status: STATUSES.sample
#   )

#   user_team.save if user_team.valid?
# end