# frozen_string_literal: true

module GraphqlAuthorize
  module FieldResolveStep
    def call(_parent_type, parent_object, field_definition, field_args, context, _next = nil)
      if authorized?(field_definition, parent_object, field_args, context)
        super
      else
        GraphQL::ExecutionError.new("Access to the field '#{field_definition.name}' is denied!")
      end
    rescue Exception => err
      GraphQL::ExecutionError.new(err.inspect)
    end

    private

    def authorized?(field_definition, object, args, context)
      return true if field_definition.authorize.nil?

      if field_definition.authorize.is_a?(Proc)
        field_definition.authorize.call(object, args, context)
      elsif field_definition.authorize.is_a?(Array) && defined?(Ability)
        action, subject = field_definition.authorize
        Ability.new(context[:current_user]).can?(action, subject)
      else
        false
      end
    end
  end
end
