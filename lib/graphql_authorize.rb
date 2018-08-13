# frozen_string_literal: true

require "graphql"

require "graphql_authorize/version"
require "graphql_authorize/ext/field"
require "graphql_authorize/ext/field_resolve_step"

module GraphqlAuthorize
  GraphQL::Field.include(GraphqlAuthorize::Field)

  GraphQL::Execution::Execute::FieldResolveStep.singleton_class.prepend(
    GraphqlAuthorize::FieldResolveStep
  )
end
