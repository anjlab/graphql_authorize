# frozen_string_literal: true

module GraphqlAuthorize
  module SchemaField
    def self.included(base)
      base.accepts_definition :authorize
    end

    attr_accessor :authorize
  end
end
