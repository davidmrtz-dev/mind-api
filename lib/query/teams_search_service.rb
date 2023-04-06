module Query
  class TeamSearchService < ApplicationService
    attr_reader :records, :params

    def initialize(records, params)
      @records = records
      @params = params
    end

    def process
      raise_invalid_params unless valid_params
    end

    private

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