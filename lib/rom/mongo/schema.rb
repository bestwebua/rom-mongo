# frozen_string_literal: true

module ROM
  module Mongo
    class Schema < ROM::Schema
      # :nocov:
      def to_output_hash
        Types::Hash
          .schema(to_h { |attr| [attr.key, attr.to_read_type] })
          .with_key_transform(&:to_sym)
      end
      # :nocov:
    end
  end
end
