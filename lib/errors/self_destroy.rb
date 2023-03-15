module Errors
  class SelfDestroy < StandardError
    def message
      'Not allowed self destroy'
    end
  end
end