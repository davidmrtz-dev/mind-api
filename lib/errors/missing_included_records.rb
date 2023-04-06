module Errors
  class MissingIncludedRecords < StandardError
    def message
      'Missing inclusion of related records'
    end
  end
end