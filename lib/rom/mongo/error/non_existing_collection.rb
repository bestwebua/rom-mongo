# frozen_string_literal: true

module ROM
  module Mongo
    module Error
      NonExistingCollection = ::Class.new(::RuntimeError) do
        def initialize(collection_namespace)
          super("Non existing collection: #{collection_namespace}")
        end
      end
    end
  end
end
