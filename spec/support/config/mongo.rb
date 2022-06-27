# frozen_string_literal: true

require 'mongo'

module MongoClient
  URL = 'mongodb://127.0.0.1:27017/rom_mongodb_test'

  class << self
    def connection
      @connection ||= Mongo::Client.new(MongoClient::URL)
    end

    def drop_db!
      connection.database.drop
    end
  end
end

RSpec.configure do |config|
  config.before(type: :integration) do
    MongoClient.drop_db!
  end
end
