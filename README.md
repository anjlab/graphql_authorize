[![Build Status](https://travis-ci.org/anjlab/graphql_authorize.svg?branch=master)](https://travis-ci.org/anjlab/graphql_authorize)

# GraphqlAuthorize


This gem allows you to authorize an access to you graphql-fields (defined by [graphql-ruby](https://github.com/rmosolgo/graphql-ruby)). For now, we support only 1.6 version :(

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql_authorize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql_authorize

## Usage

You can define a proc and pass it to `authorize` inside the field block:

```ruby
field :posts, types[PostType] do
  authorize lambda { |_obj, _args, context|
    current_user = context[:current_user]
    current_user && current_user.admin
  }

  resolve ->(_obj, _args, _context) { ... }
end
```

Don't forget to pass `current_user` to the context when you execute the query, e.g.:

```ruby
Schema.execute(query, context: { current_user: current_user })
```

### CanCanCan

If you are using CanCanCan, you can just pass an array with two values - permission to check and a model class:

```ruby
field :posts, types[PostType] do
  authorize [:read, Post]
  resolve ->(_obj, _args, _context) { ... }
end
```

In order to let GraphqlAuthorize know that it should use CanCanCan, please configure it somewhere in your app:

```ruby
GraphqlAuthorize.config.auth_adapter = GraphqlAuthorize::AuthAdapters::CanCanCan
```

By default it will try to call `can?` on the module called `Ability` (you have it if you follow the [guide](https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities)). However, when you've done it in a different way, you must also configure `auth_adapter_source` - a proc, which will get a current context and will need to return something, which can respond to `can?`:

```ruby
GraphqlAuthorize.configure do |config|
  config.auth_adapter = GraphqlAuthorize::AuthAdapters::CanCanCan
  config.auth_adapter_source = ->(context) { context[:current_user] }
end
```

### Pundit

Pundit integration is very similar with CanCanCan - you should pass an array with two values in a following way:

```ruby
field :posts, types[PostType] do
  authorize [:read, Post]
  resolve ->(_obj, _args, _context) { ... }
end
```

Don't forget to configure GraphqlAuthorize to use the proper adapter:

```ruby
GraphqlAuthorize.config.auth_adapter = GraphqlAuthorize::AuthAdapters::Pundit
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anjlab/graphql_authorize.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
