# frozen_string_literal: true

require "active_support"
require "pundit"

require "spec_helper"

describe "Pundit" do
  let(:query) { build_graphql_query("posts", selections: %i[id title]) }

  PunditQueryType = GraphQL::ObjectType.define do
    name "PunditQueryType"

    field :posts, types[PostType] do
      authorize [:read, Post]
      resolve ->(_obj, _args, _context) { [] }
    end
  end

  PunditSchema = GraphQL::Schema.define { query(PunditQueryType) }

  context "with ability" do
    before(:each) do
      PostPolicy = Class.new do
        attr_reader :user, :post

        def initialize(user, post)
          @user = user
          @post = post
        end

        def read?
          user.admin
        end
      end
    end

    after(:each) { Object.send(:remove_const, :PostPolicy) }

    let(:admin) { User.new(true) }
    let(:guest) { User.new(false) }

    it "returns error when adapter is not configured" do
      result_hash = PunditSchema.execute(query, context: { current_user: admin })

      expect(result_hash.dig("data", "posts")).to be_nil
      expect(result_hash["errors"].first["message"]).to eq("Access to the field 'posts' is denied!")
    end

    it "returns error when user has no permission" do
      GraphqlAuthorize.config.auth_adapter = GraphqlAuthorize::AuthAdapters::Pundit

      result_hash = PunditSchema.execute(query, context: { current_user: guest })

      expect(result_hash.dig("data", "posts")).to be_nil
      expect(result_hash["errors"].first["message"]).to eq("Access to the field 'posts' is denied!")
    end

    it "returns date when user has permission" do
      GraphqlAuthorize.config.auth_adapter = GraphqlAuthorize::AuthAdapters::Pundit

      result_hash = PunditSchema.execute(query, context: { current_user: admin })

      expect(result_hash.dig("data", "posts")).to eq([])
      expect(result_hash["errors"]).to be_nil
    end
  end
end
