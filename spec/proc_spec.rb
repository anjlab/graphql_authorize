# frozen_string_literal: true

require "active_support"
require "cancancan"

require "spec_helper"

describe "proc" do
  let(:admin) { User.new(true) }
  let(:guest) { User.new(false) }
  let(:query) { build_graphql_query("posts", selections: %i[id title]) }

  ProcQueryType = GraphQL::ObjectType.define do
    name "ProcQueryType"

    field :posts, types[PostType] do
      authorize lambda { |_obj, _args, context|
        current_user = context[:current_user]
        current_user && current_user.admin
      }

      resolve ->(_obj, _args, _context) { [] }
    end
  end

  ProcSchema = GraphQL::Schema.define { query(ProcQueryType) }

  it "returns error when user has no permission" do
    result_hash = ProcSchema.execute(query, context: { current_user: guest })

    expect(result_hash.dig("data", "posts")).to be_nil
    expect(result_hash["errors"].first["message"]).to eq("Access to the field 'posts' is denied!")
  end

  it "returns date when user has permission" do
    result_hash = ProcSchema.execute(query, context: { current_user: admin })

    expect(result_hash.dig("data", "posts")).to eq([])
    expect(result_hash["errors"]).to be_nil
  end
end
