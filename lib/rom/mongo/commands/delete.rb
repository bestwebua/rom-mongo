# frozen_string_literal: true

module ROM
  module Mongo
    module Commands
      # Delete command
      #
      # Removes tuple from its target relation
      #
      # @abstract
      class Delete < ROM::Commands::Delete
        include ROM::Mongo::Commands::Helper

        adapter :mongo

        # Passes tuple to relation for deletion
        #
        # @param attributes [Hash]
        #
        # @return [Array<Hash>]
        #
        # @api public
        def execute(attributes)
          filtered_documents = dataset.find(pk.merge(attributes), projection)
          document_snapshot = process_with_schema(filtered_documents.first)
          return [document_snapshot] if filtered_documents.delete_one.deleted_count.eql?(1)

          []
        end
      end
    end
  end
end
