# frozen_string_literal: true

module GraphqlAuthorize
  module Field
    def self.included(base)
      base.accepts_definitions :authorize
    end

    attr_accessor :authorize
  end
end
