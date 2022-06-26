# frozen_string_literal: true

module ROM
  module Mongo
    module Commands
      # Update command
      #
      # Updates tuple in its relation with new attributes
      #
      # @abstract
      class Update < ROM::Commands::Update
        include ROM::Mongo::Commands::Helper

        adapter :mongo

        # Passes tuple to relation for updation
        #
        # @param attributes [Hash]
        #
        # @return [Array<Hash>]
        #
        # @api public
        def execute(attributes)
          document = process_with_schema(pk.merge(attributes))
          return [document] if dataset.collection.update_one(pk, attributes).modified_count.eql?(1)

          []
        end
      end
    end
  end
end
