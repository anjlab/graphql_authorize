# frozen_string_literal: true

require "graphql_authorize"
require "i18n"

RSpec.configure do |config|
  config.order = :random

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.formatter = :documentation
  config.color = true

  config.after(:each) do
    if GraphqlAuthorize.instance_variable_defined?(:@config)
      GraphqlAuthorize.remove_instance_variable(:@config)
    end
  end

  autoload :PostType, File.dirname(__FILE__) + "/schema/post_type.rb"
  autoload :CommentType, File.dirname(__FILE__) + "/schema/comment_type.rb"
end

def build_graphql_selections_text(input)
  input.map do |field|
    if field.is_a? Hash
      field.map { |key, value| "#{key} { #{build_graphql_selections_text(value)} }" }
    else
      field.to_s
    end
  end.flatten.join(" ")
end

def build_graphql_query(field_name, selections: nil, kind: :query)
  <<~QUERY
    #{kind} {
      #{field_name}() {
        #{build_graphql_selections_text(Array(selections))}
      }
    }
  QUERY
end

Post = Struct.new(:title)
User = Struct.new(:admin)
