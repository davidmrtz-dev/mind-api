require 'rails_helper'

RSpec.describe Api::AccountsController, type: :controller do
  describe 'GET /api/accounts' do
    login_user

    it 'return accounts' do
      get :index

      expect(response).to have_http_status(:ok)
      expect(parsed_response[:accounts].map { |a| a[:id] }).to match_array(Account.ids)
    end
  end
end