# frozen_string_literal: true

PostType = GraphQL::ObjectType.define do
  name "PostType"

  field :id, types.Int
  field :title, types.String
  field :comments, types[CommentType]
end
