# frozen_string_literal: true

require "active_support"
require "cancancan"

require "spec_helper"

describe "CanCanCan" do
  let(:query) { build_graphql_query("posts", selections: %i[id title]) }

  before { GraphqlAuthorize.config.auth_adapter = nil }

  CanCanCanQueryType = GraphQL::ObjectType.define do
    name "CanCanCanQueryType"

    field :posts, types[PostType] do
      authorize [:read, Post]
      resolve ->(_obj, _args, _context) { [] }
    end
  end

  CanCanCanSchema = GraphQL::Schema.define { query(CanCanCanQueryType) }

  context "with ability" do
    before(:each) do
      Ability = Class.new do
        include CanCan::Ability

        def initialize(user)
          can(:manage, Post) if user&.admin
        end
      end
    end

    after(:each) { Object.send(:remove_const, :Ability) }

    let(:admin) { User.new(true) }
    let(:guest) { User.new(false) }

    it "returns error when adapter is not configured" do
      result_hash = CanCanCanSchema.execute(query, context: { current_user: admin })

      expect(result_hash.dig("data", "posts")).to be_nil
      expect(result_hash["errors"].first["message"]).to eq("Access to the field 'posts' is denied!")
    end

    it "returns error when user has no permission" do
      GraphqlAuthorize.config.auth_adapter = GraphqlAuthorize::Configuration::CAN_CAN_CAN

      result_hash = CanCanCanSchema.execute(query, context: { current_user: guest })

      expect(result_hash.dig("data", "posts")).to be_nil
      expect(result_hash["errors"].first["message"]).to eq("Access to the field 'posts' is denied!")
    end

    it "returns date when user has permission" do
      GraphqlAuthorize.config.auth_adapter = GraphqlAuthorize::Configuration::CAN_CAN_CAN

      result_hash = CanCanCanSchema.execute(query, context: { current_user: admin })

      expect(result_hash.dig("data", "posts")).to eq([])
      expect(result_hash["errors"]).to be_nil
    end
  end

  context "with custom source" do
    CustomAbility = Class.new do
      include CanCan::Ability

      def initialize(user)
        can(:manage, Post) if user&.admin
      end
    end

    CustomUser = Struct.new(:admin) do
      def ability
        @ability ||= CustomAbility.new(self)
      end

      delegate :can?, to: :ability
    end

    let(:admin) { CustomUser.new(true) }
    let(:guest) { CustomUser.new(false) }

    before(:each) do
      GraphqlAuthorize.config.auth_adapter = GraphqlAuthorize::Configuration::CAN_CAN_CAN
      GraphqlAuthorize.config.auth_adapter_source = ->(context) { context[:current_user] }
    end

    it "returns error when user has no permission" do
      result_hash = CanCanCanSchema.execute(query, context: { current_user: guest })

      expect(result_hash.dig("data", "posts")).to be_nil
      expect(result_hash["errors"].first["message"]).to eq("Access to the field 'posts' is denied!")
    end

    it "returns date when user has permission" do
      result_hash = CanCanCanSchema.execute(query, context: { current_user: admin })

      expect(result_hash.dig("data", "posts")).to eq([])
      expect(result_hash["errors"]).to be_nil
    end
  end
end
