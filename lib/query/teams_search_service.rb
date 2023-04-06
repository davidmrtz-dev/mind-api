module Query
  class TeamSearchService < ApplicationService
    attr_reader :records, :params

    def initialize(records, params)
      @records = records
      @params = params
    end

    def process
      raise_invalid_params unless valid_params

      if query_by_keyword?
        records.where(
          'LOWER(name) LIKE :word', word: "%#{params[:keyword].downcase}%"
        )
      else
        start_at = Date.parse(params[:start_at])
        end_at = Date.parse(params[:end_at])

        begin
          query_by_dates? ?
            query_by_dates(records, start_at, end_at) :
            query_by_key_and_dates(records, start_at, end_at, params[:keyword])
        rescue
          raise Errors::MissingIncludedRecords
        end
      end
    end

    private

    def query_by_dates(records, start_at, end_at)
      rec = records.where({ user_teams: { start_at: start_at, end_at: end_at }})
      rec.first!
      rec
    end

    def query_by_key_and_dates(records, start_at, end_at, keyword)
      rec = records.where('LOWER(name) LIKE :word', word: "%#{keyword.downcase}%")
        .where({ user_teams: { start_at: start_at, end_at: end_at }})
      rec.first!
      rec
    end

    def raise_invalid_params
      raise Errors::InvalidParameters
    end

    def valid_params
      return true if query_by_keyword? ||
        query_by_dates? || query_by_key_and_dates?

      false
    end

    def query_by_keyword?
      with_keyword? && !with_start_at? && !with_end_at?
    end

    def query_by_dates?
      !with_keyword? && with_start_at? && with_end_at?
    end

    def query_by_key_and_dates?
      with_keyword? && with_start_at? && with_end_at?
    end

    def with_keyword?
      params[:keyword].present?
    end

    def with_start_at?
      params[:start_at].present?
    end

    def with_end_at?
      params[:end_at].present?
    end
  end
end