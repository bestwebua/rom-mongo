# frozen_string_literal: true

require_relative 'mongo/core'

ROM.register_adapter(:mongo, ROM::Mongo)
