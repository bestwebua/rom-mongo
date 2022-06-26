# frozen_string_literal: true

module ROM
  module Mongo
    module Commands
      module Helper
        private

        # @api private
        def dataset
          relation.dataset
        end

        # @api private
        def pk
          return {} unless dataset.respond_to?(:filter)

          dataset.filter.transform_keys(&:to_sym)
        end

        # @api private
        def process_with_schema(attributes)
          schema.to_output_hash.call(attributes)
        end

        # @api private
        def schema
          relation.schema
        end

        # @api private
        def schema_attributes
          schema
            .attributes
            .map(&:name)
            .each_with_object({}) { |item, hash| hash[item] = true }
        end

        # @api private
        def projection
          { projection: schema_attributes }
        end
      end
    end
  end
end
