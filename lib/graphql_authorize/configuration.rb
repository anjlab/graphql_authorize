# frozen_string_literal: true

module GraphqlAuthorize
  class Configuration
    attr_reader :auth_adapter
    attr_accessor :auth_adapter_source

    CAN_CAN_CAN = :can_can_can

    ADAPTERS = [CAN_CAN_CAN].freeze

    def initialize
      @auth_adapter = nil
      @auth_adapter_source = nil
    end

    def auth_adapter=(value)
      if value && !ADAPTERS.include?(value)
        raise ArgumentError, "Unsupported auth adapter #{value} was passed, here is a list of " \
                             "supported adapters: #{ADAPTERS.join(',')}"
      end

      @auth_adapter = value
    end
  end
end
