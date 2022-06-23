# frozen_string_literal: true

require 'rom/core'

module ROM
  module Mongo
    module Error
      require_relative '../mongo/error/non_existing_collection'
    end

    require_relative '../mongo/version'
    require_relative '../mongo/dataset'
    require_relative '../mongo/gateway'
  end
end
