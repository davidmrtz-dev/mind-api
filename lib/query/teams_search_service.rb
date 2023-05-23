module Query
  class TeamsSearchService < ApplicationService
    attr_reader :records, :params

    def initialize(records, params)
      @records = records
      @params = params
    end

    def process
      keyword = params[:keyword]
      start_at =  Date.parse(params[:start_at]) if params[:start_at].present?
      end_at = Date.parse(params[:end_at]) if params[:end_at].present?

      begin
        query(records, keyword, start_at: start_at, end_at: end_at)
      rescue
        raise Errors::MissingIncludedRecords
      end
    end

    private

    def query(records, keyword, start_at: nil, end_at: nil)
      rec = records.where('LOWER(name) LIKE :word', word: "%#{keyword.downcase}%")
      rec = rec.where({ user_teams: { start_at: start_at, end_at: end_at }}) if start_at.present? && end_at.present?
      rec.first
      rec
    end
  end
end