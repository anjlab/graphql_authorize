# frozen_string_literal: true

module GraphqlAuthorize
  module FieldResolveStep
    # rubocop:disable Metrics/ParameterLists
    def call(_parent_type, parent_object, field_definition, field_args, context, _next = nil)
      if authorized?(field_definition, parent_object, field_args, context)
        super
      else
        GraphQL::ExecutionError.new("Access to the field '#{field_definition.name}' is denied!")
      end
    rescue StandardError => err
      GraphQL::ExecutionError.new(err.inspect)
    end
    # rubocop:enable Metrics/ParameterLists

    private

    def authorized?(field_definition, object, args, context)
      return true if field_definition.authorize.nil?

      if field_definition.authorize.is_a?(Proc)
        return field_definition.authorize.call(object, args, context)
      end

      if auth_adapter == GraphqlAuthorize::Configuration::CAN_CAN_CAN
        return authorize_with_can_can_can(field_definition, context)
      end

      false
    end

    # rubocop:disable Metrics/MethodLength
    def authorize_with_can_can_can(field_definition, context)
      unless field_definition.authorize.is_a?(Array)
        raise ArgumentError,
              "#authorize arguments should be passed as array, e.g. `authorize [:read, Post]`"
      end

      source =
        if auth_adapter_source
          auth_adapter_source.call(context)
        else
          Ability.new(context[:current_user])
        end
      unless source.respond_to?(:can?)
        raise ArgumentError,
              "an object returned by #auth_adapter_source call does not respond to #can?"
      end

      source.can?(*field_definition.authorize)
    end
    # rubocop:enable Metrics/MethodLength

    def auth_adapter
      GraphqlAuthorize.config.auth_adapter
    end

    def auth_adapter_source
      GraphqlAuthorize.config.auth_adapter_source
    end
  end
end
