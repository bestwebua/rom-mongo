# frozen_string_literal: true

module ROM
  module Mongo
    # Mongo specific relation extensions
    class Relation < ROM::Relation
      adapter :mongo
      schema_class ROM::Mongo::Schema
      option :output_schema, default: -> { schema.to_output_hash }
      forward :find, :sort, :limit, :skip

      # @api private
      def self.view_methods
        super + [:by_pk]
      end

      # Returns relation restricted by _id
      #
      # @param id [BSON::ObjectId] Document's PK value
      #
      # @return [ROM::Mongo::Relation]
      #
      # @api public
      auto_curry def by_pk(id)
        find(_id: id)
      end

      # Single purpose aggregation operations

      # Difines count for dataset
      #
      # @return [Integer] The total count of documents
      #
      # @api public
      def count
        dataset.count
      end

      # Difines distinct for dataset
      #
      # @param [Symbol] attribute The document field name
      #
      # @return [Array<String>] The collection of uniq values by field name
      #
      # @api public
      def distinct(attribute)
        dataset.distinct(attribute)
      end
    end
  end
end
