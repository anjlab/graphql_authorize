# frozen_string_literal: true

module GraphqlAuthorize
  module AuthAdapters
    class Base
      attr_reader :field_definition, :context

      def initialize(field_definition, context)
        @field_definition = field_definition
        @context = context
      end
    end
  end
end
