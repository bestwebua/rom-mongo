# frozen_string_literal: true

require 'rom/core'

module ROM
  module Mongo
    require_relative '../mongo/version'
    require_relative '../mongo/dataset'
    require_relative '../mongo/gateway'
    require_relative '../mongo/schema'
    require_relative '../mongo/relation'
  end
end
