# GraphqlAuthorize

This gem allows you to authorize an access to you graphql-fields (defined by [graphql-ruby](https://github.com/rmosolgo/graphql-ruby)).

You can define an proc an pass it to `authorize` inside the field block:

```ruby
field :posts, types[PostType] do
  authorize lambda { |_obj, _args, context|
    current_user = context[:current_user]
    current_user && current_user.admin
  }

  resolve ->(_obj, _args, _context) { ... }
end
```

Alternatively, if you are using CanCanCan, you can just pass an array with two values - permission to check and a model class:

```ruby
field :posts, types[PostType] do
  authorize [:read, Post]
  resolve ->(_obj, _args, _context) { ... }
end
```

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

TODO: Write usage instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anjlab/graphql_authorize.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
