# frozen_string_literal: true

module GraphqlAuthorize
  module FieldResolveStep
    # rubocop:disable Metrics/ParameterLists
    def call(_parent_type, parent_object, field_definition, field_args, context, _next = nil)
      if authorized?(field_definition, parent_object, field_args, context)
        super
      else
        GraphQL::ExecutionError.new(
          I18n.t("graphql_authorize.graphql.accessdenied", name: field_definition.name)
        )
      end
    end
    # rubocop:enable Metrics/ParameterLists

    private

    def authorized?(field_definition, object, args, context)
      return true if field_definition.authorize.nil?

      if field_definition.authorize.is_a?(Proc)
        return field_definition.authorize.call(object, args, context)
      end

      return false if auth_adapter.nil?

      auth_adapter.new(field_definition, context).authorize
    end

    def auth_adapter
      GraphqlAuthorize.config.auth_adapter
    end
  end
end
