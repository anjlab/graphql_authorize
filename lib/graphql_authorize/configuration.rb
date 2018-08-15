# frozen_string_literal: true

module GraphqlAuthorize
  class Configuration
    attr_accessor :auth_adapter_source, :auth_adapter

    def initialize
      @auth_adapter = nil
      @auth_adapter_source = nil
    end
  end
end
