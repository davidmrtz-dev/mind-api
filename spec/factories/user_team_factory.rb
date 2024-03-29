class UserTeamFactory < BaseFactory
  def self.described_class
    UserTeam
  end

  private

  def options(params)
    {
      user: params.fetch(:user),
      team: params.fetch(:team),
      start_at: params.fetch(:start_at, Time.zone.today),
      end_at: params.fetch(:end_at, Time.zone.tomorrow),
      status: params.fetch(:status, :inactive)
    }
  end
end