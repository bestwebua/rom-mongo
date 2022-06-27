# frozen_string_literal: true

module ROM
  module Mongo
    # Class interfacing with the MongoDB Ruby driver
    # Provides a DSL for constructing queries
    class Dataset
      # The collection object
      #
      # @return [Mongo::Collection] The collection object
      #
      # @api public
      attr_reader :collection

      # Initializes the Dataset object
      #
      # @example Create a Dataset object.
      #   ROM::Mongo::Dataset.new(collection)
      #
      # @param [Mongo::Collection] collection The collection to run the operation on
      #
      # @api public
      def initialize(collection)
        @collection = collection
      end

      # Constructs a collection view with a given selector
      #
      # @example Define ascending order by the name
      #   dataset_instance.find(
      #     { company: 'Some Company' },
      #     { projection: { _id: true, name: true, email: true, company: true } }
      #   )
      #
      # @param [Hash] options The query criteria
      # @param [Hash] projection The projection criteria
      #
      # @return [Mongo::Collection::View] The collection view object
      #
      # @api public
      def find(options = {}, projection = {})
        view(options, projection)
      end

      # Difines order for collection view
      #
      # @example Define ascending order by the name
      #   dataset_instance.sort(name: 1)
      #
      # @param [Hash] attributes The order criteria.
      #
      # @return [Mongo::Collection::View] The collection view object
      #
      # @api public
      def sort(attributes)
        view.sort(attributes)
      end

      # Difines limit for collection view
      #
      # @example Define ascending order by the name
      #   dataset_instance.limit(42)
      #
      # @param [Integer] count The limit criteria.
      #
      # @return [Mongo::Collection::View] The collection view object
      #
      # @api public
      def limit(count)
        view.limit(count)
      end

      # Difines skip for collection view
      #
      # @example Define ascending order by the name
      #   dataset_instance.skip(2)
      #
      # @param [Integer] count The limit criteria
      #
      # @return [Mongo::Collection::View] The collection view object
      #
      # @api public
      def skip(count)
        view.skip(count)
      end

      # Difines interface to insert one or more new documents
      #
      # @example Inserting one document
      #   dataset_instance.insert({ name: 'Some Name', email: 'olo@molo.com' })
      #
      # @example Inserting more than one document
      #   dataset_instance.insert(
      #     { name: 'One', email: 'olo@domain.com' },
      #     { name: 'Two', email: 'molo@domain.com' }
      #   )
      #
      # @param [Hash] attributes The attributes for new document
      #
      # @return [Array<String>] The array with inserted ids
      #
      # @api public
      def insert(*attributes)
        method_params =
          attributes.one? ? [:insert_one, *attributes] : [:insert_many, attributes]
        collection.public_send(*method_params).inserted_ids
      end

      # Difines count for collection view
      #
      # @example Define ascending order by the name
      #   dataset_instance.count
      #
      # @return [Integer] The total count of documents
      #
      # @api public
      def count
        view.count
      end

      # Difines distinct for collection view
      #
      # @example Define ascending order by the name
      #   dataset_instance.distinct(:some_attribute)
      #
      # @param [Symbol] attribute The document field name
      #
      # @return [Array<String>] The collection of uniq values by field name
      #
      # @api public
      def distinct(attribute)
        view.distinct(attribute)
      end

      # Difines view without options
      #
      # @return [Mongo::Collection::View] The collection view object
      #
      # @api public
      def to_a
        view
      end

      # @api private
      def map(&block)
        to_a.map(&block)
      end

      private

      # Applies given options to the view
      #
      # @return [Mongo::Collection::View] The collection view object
      #
      # @api private
      def view(options = {}, projection = {})
        collection.find(options, projection)
      end
    end
  end
end
