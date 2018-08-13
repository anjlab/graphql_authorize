# frozen_string_literal: true

CommentType = GraphQL::ObjectType.define do
  name "CommentType"

  field :id, types.Int
  field :post, PostType
end
