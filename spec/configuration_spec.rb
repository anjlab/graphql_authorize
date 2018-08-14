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

    it "acceptes can_can_can" do
      subject.auth_adapter = GraphqlAuthorize::Configuration::CAN_CAN_CAN
      expect(subject.auth_adapter).to eq(GraphqlAuthorize::Configuration::CAN_CAN_CAN)
    end

    it "raises an error when adapter is unknown" do
      expect { subject.auth_adapter = :unknown }.to raise_exception(ArgumentError)
      expect(subject.auth_adapter).to eq(nil)
    end
  end
end
