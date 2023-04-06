module Errors
  class InvalidParameters < StandardError
    def message
      'Parameters are not valid'
    end
  end
end