# frozen_string_literal: true

module ROM
  module Mongo
    module IntegrationHelper
      def client
        MongoClient.connection
      end

      def collection(collection_name)
        client[collection_name]
      end

      def collection_size(collection_name)
        collection(collection_name).count
      end
    end
  end
end
