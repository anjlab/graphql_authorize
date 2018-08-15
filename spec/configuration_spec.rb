# frozen_string_literal: true

require "active_support"
require "cancancan"

require "spec_helper"

describe GraphqlAuthorize::Configuration do
  subject { described_class.new }

  context "#auth_adapter" do
    it "adapter is nil by default" do
      expect(subject.auth_adapter).to be_nil
    end

    it "accepts can_can_can" do
      subject.auth_adapter = GraphqlAuthorize::AuthAdapters::CanCanCan
      expect(subject.auth_adapter).to eq(GraphqlAuthorize::AuthAdapters::CanCanCan)
    end
  end
end
