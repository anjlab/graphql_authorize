# frozen_string_literal: true

require "graphql"

require "graphql_authorize/version"
require "graphql_authorize/configuration"
require "graphql_authorize/auth_adapters/base"
require "graphql_authorize/auth_adapters/can_can_can"
require "graphql_authorize/auth_adapters/pundit"

require "graphql_authorize/ext/field"
require "graphql_authorize/ext/schema_field"
require "graphql_authorize/ext/field_resolve_step"

module GraphqlAuthorize
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end

    def supports_class_syntax?
      Gem.loaded_specs["graphql"].version >= Gem::Version.create("1.8")
    end
  end

  I18n.load_path += Dir[File.expand_path(__dir__ + "/../config/locales/*.yml")]

  GraphQL::Field.include(GraphqlAuthorize::Field)

  GraphQL::Schema::Field.include(GraphqlAuthorize::SchemaField) if supports_class_syntax?

  GraphQL::Execution::Execute::FieldResolveStep.singleton_class.prepend(
    GraphqlAuthorize::FieldResolveStep
  )
end
