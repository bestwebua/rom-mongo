# MongoDB adapter for Ruby Object Mapper

[![Maintainability](https://api.codeclimate.com/v1/badges/5b38ebba392bd37f166b/maintainability)](https://codeclimate.com/github/bestwebua/rom-mongo/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5b38ebba392bd37f166b/test_coverage)](https://codeclimate.com/github/bestwebua/rom-mongo/test_coverage)
[![CircleCI](https://circleci.com/gh/bestwebua/rom-mongo/tree/master.svg?style=svg)](https://circleci.com/gh/bestwebua/rom-mongo/tree/master)
[![Gem Version](https://badge.fury.io/rb/rom-mongodb.svg)](https://badge.fury.io/rb/rom-mongodb)
[![Downloads](https://img.shields.io/gem/dt/rom-mongodb.svg?colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/rom-mongodb)
[![GitHub](https://img.shields.io/github/license/bestwebua/rom-mongo)](LICENSE.txt)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

`rom-mongodb` - MongoDB adapter for [ROM](https://rom-rb.org). What is ROM? It's a fast ruby persistence library with the goal of providing powerful object mapping capabilities without limiting the full power of the underlying datastore.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Credits](#credits)
- [Versioning](#versioning)
- [Changelog](CHANGELOG.md)

## Requirements

Ruby MRI 2.5.0+

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'rom-mongodb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rom-mongodb

## Usage

```ruby
# Define your container with mongo adapter

require 'mongo'
require 'rom'
require 'rom/mongodb'

connection = Mongo::Client.new('mongodb://127.0.0.1:27017/your_db_name')
container = ROM.container(:mongo, connection) do |config|
  config.relation(:users) do
    schema(:users) do
      attribute :_id, ROM::Types.Nominal(BSON::ObjectId)
      attribute :email, ROM::Types::String
      attribute :rating, ROM::Types::Integer
      attribute :status, ROM::Types::Bool
    end
  end
end

# Define your repository

require 'rom/repository'

User = ::Class.new(ROM::Repository[:users]) do
  commands(:create, :delete, update: :by_pk)

  def all
    users.to_a
  end

  def find(**options)
    users.find(options)
  end
end

user_repository = User.new(container)

# Now you can do some manipulations with your repository

user_repository.create({ email: 'olo@domain.com', rating: 42, status: true })
user_repository.all
user_repository.find(email: 'olo@domain.com')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bestwebua/rom-mongo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Please check the [open tickets](https://github.com/bestwebua/rom-mongo/issues). Be sure to follow Contributor Code of Conduct below and our [Contributing Guidelines](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the rom-mongodb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Credits

- [The Contributors](https://github.com/bestwebua/rom-mongo/graphs/contributors) for code and awesome suggestions
- [The Stargazers](https://github.com/bestwebua/rom-mongo/stargazers) for showing their support

## Versioning

rom-mongodb uses [Semantic Versioning 2.0.0](https://semver.org)
