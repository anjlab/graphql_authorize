# frozen_string_literal: true

require "graphql_authorize"

RSpec.configure do |config|
  config.order = :random

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.formatter = :documentation
  config.color = true

  def build_graphql_selections_text(input)
    input.map do |field|
      if field.is_a? Hash
        field.map { |key, value| "#{key} { #{build_graphql_selections_text(value)} }" }
      else
        field.to_s
      end
    end.flatten.join(" ")
  end

  def build_graphql_query(field_name, args: {}, selections: nil, kind: :query)
    <<~QUERY
      #{kind} {
        #{field_name}() {
          #{build_graphql_selections_text(Array(selections))}
        }
      }
    QUERY
  end

  autoload :PostType, File.dirname(__FILE__) + "/schema/post_type.rb"
  autoload :CommentType, File.dirname(__FILE__) + "/schema/comment_type.rb"
end
