# frozen_string_literal: true

module ROM
  module Mongo
    # Wrapping the mongo collections to dataset abstractions
    # and passing them to the relations
    #
    # @abstract
    class Gateway < ROM::Gateway
      adapter :mongo

      # Builded datasets
      #
      # @return [Hash] The hash with datasets
      #
      # @api public
      attr_reader :datasets

      # Initializes the Gateway object
      #
      # @example Create a Gateway object
      #   ROM::Mongo::Gateway.new(client)
      #
      # @param [Mongo::Client] client The mongo client instance
      #
      # @api public
      def initialize(client)
        @client = client
        @datasets = {}
      end

      # Buildes dataset with the given name
      #
      # @param [Symbol] name dataset name
      #
      # @param [Class] dataset_class dataset class
      #
      # @return [ROM::Mongo::Dataset]
      #
      # @api public
      def dataset(name, dataset_class = ROM::Mongo::Dataset)
        datasets[name] = dataset_class.new(client[name])
      end

      # Checkes if dataset exists
      #
      # @param [Symbol] name dataset name
      #
      # @return [true, false]
      #
      # @api public
      def dataset?(name)
        datasets.key?(name)
      end

      # Retrieves dataset with the given name
      #
      # @param [Symbol] name dataset name
      #
      # @return [ROM::Mongo::Dataset, nil]
      #
      # @api public
      def [](name)
        datasets[name]
      end

      private

      # @api private
      attr_reader :client
    end
  end
end
