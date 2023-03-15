require 'faker'

class ProfileFactory < BaseFactory
  def self.described_class
    Profile
  end

  private

  def options(params)
    {
      user: params.fetch(:user),
      english_level: params.fetch(:english_level, :a1),
      technical_knowledge: params.fetch(:technical_knowledge, 'Docker'),
      cv: params.fetch(:cv, 'link to my cv')
    }
  end
end