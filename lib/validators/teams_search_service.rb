module Validators
  class TeamSearchService
    class << self
      def valid_params?(params)
        hashed = with_params(params)
        query_by_keyword?(hashed) || query_by_dates?(hashed) || query_by_key_and_dates?(hashed)
      end

      private

      def query_by_keyword?(with_params)
        with_params[:keyword] && !with_params[:start_at] && !with_params[:end_at]
      end

      def query_by_dates?(with_params)
        !with_params[:keyword] && with_params[:start_at] && with_params[:end_at]
      end

      def query_by_key_and_dates?(with_params)
        with_params[:keyword] && with_params[:start_at] && with_params[:end_at]
      end

      def with_params(params)
        {
          keyword: params[:keyword].present?,
          start_at: params[:start_at].present?,
          end_at: params[:end_at].present?,
        }
      end
    end
  end
end