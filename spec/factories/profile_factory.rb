require 'faker'

TECHNOLOGIES = ['Docker', 'AWS', 'Azure', 'React', 'SQL', 'Redux', 'Postgres', '.NET', 'Bash', 'RoR']
ENGLISH_LEVELS = ['a1', 'a2', 'b1', 'b2', 'c1', 'c2']

class ProfileFactory < BaseFactory
  def self.described_class
    Profile
  end

  private

  def options(params)
    {
      user: params.fetch(:user),
      english_level: params.fetch(:english_level, ENGLISH_LEVELS.sample),
      technical_knowledge: params.fetch(:technical_knowledge, TECHNOLOGIES.take(3).join(', ')),
      cv: params.fetch(:cv, 'https://user-example-cv.com')
    }
  end
end