# frozen_string_literal: true

module ROM
  module Mongo
    module ContextGeneratorHelper
      def random_positive_number
        ::Kernel.rand(1..5)
      end

      def ffaker
        FFaker::InternetSE
      end

      def random_word
        ffaker.domain_word
      end

      def random_projection_options
        {
          projection: (1..random_positive_number).each_with_object({}) { |_, hash| hash[random_word.to_sym] = true }
        }
      end

      def random_filter_options
        (1..random_positive_number).each_with_object({}) do |_, hash|
          hash[random_word.to_sym] = [
            true,
            false,
            random_positive_number,
            random_word
          ].sample
        end
      end

      def random_bson_object_id
        BSON::ObjectId.new
      end

      def random_document
        { _id: random_bson_object_id, **random_filter_options }
      end

      def random_dataset(size: nil)
        ::Array.new(size || random_positive_number) { random_document }
      end
    end
  end
end
