# frozen_string_literal: true

module ROM
  module Mongo
    module Commands
      # Create command
      #
      # Inserts a new tuple into a relation
      #
      # @abstract
      class Create < ROM::Commands::Create
        include ROM::Mongo::Commands::Helper

        adapter :mongo

        # TODO: always returns :one, even more then one documents have created
        # Research how to display :many needed

        # Passes tuple to relation for insertion
        #
        # @param attributes [Hash]
        #
        # @return [Array<Hash>]
        #
        # @api public
        def execute(*attributes)
          ids = dataset.insert(*attributes)
          return [] if ids.empty?

          attributes.each_with_object([]).with_index do |(attribute, arr), index|
            arr << { _id: ids[index], **attribute }
          end
        end
      end
    end
  end
end
