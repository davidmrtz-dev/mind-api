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
        query(records, params[:keyword])
      else
        start_at = Date.parse(params[:start_at])
        end_at = Date.parse(params[:end_at])
        keyword = params[:keyword]

        begin
          query(records, keyword, start_at: start_at, end_at: end_at)
        rescue
          raise Errors::MissingIncludedRecords
        end
      end
    end

    private

    def query(records, keyword, start_at: nil, end_at: nil)
      rec = records.where('LOWER(name) LIKE :word', word: "%#{keyword.downcase}%")
      rec = rec.where({ user_teams: { start_at: start_at, end_at: end_at }}) if start_at.present? && end_at.present?
      rec.first!
      rec
    end

    def raise_invalid_params
      raise Errors::InvalidParameters
    end

    def valid_params
      query_by_keyword? || query_by_dates? || query_by_key_and_dates?
    end

    def query_by_keyword?
      with_params[:keyword] && !with_params[:start_at] && !with_params[:end_at]
    end

    def query_by_dates?
      !with_params[:keyword] && with_params[:start_at] && with_params[:end_at]
    end

    def query_by_key_and_dates?
      with_params[:keyword] && with_params[:start_at] && with_params[:end_at]
    end

    def with_params
      {
        keyword: params[:keyword].present?,
        start_at: params[:start_at].present?,
        end_at: params[:end_at].present?,
      }
    end
  end
end