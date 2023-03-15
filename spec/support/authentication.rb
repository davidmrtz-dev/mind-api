def login_user
  before(:each) do
    user = User.last.presence || User.create!(email: 'user@example.com', password: 'password', user_type: :admin)
    headers = user.create_new_auth_token
    request.headers['access-token'] = headers['access-token']
    request.headers['client'] = headers['client']
    request.headers['uid'] = headers['uid']
  end
end