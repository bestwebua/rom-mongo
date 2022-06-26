# frozen_string_literal: true

require 'rom/core'

module ROM
  module Mongo
    module Commands
      require_relative '../mongo/commands/helper'
      require_relative '../mongo/commands/create'
      require_relative '../mongo/commands/update'
      require_relative '../mongo/commands/delete'
    end

    require_relative '../mongo/version'
    require_relative '../mongo/dataset'
    require_relative '../mongo/gateway'
    require_relative '../mongo/schema'
    require_relative '../mongo/relation'
  end
end
