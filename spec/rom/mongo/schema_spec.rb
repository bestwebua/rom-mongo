# frozen_string_literal: true

RSpec.describe ROM::Mongo::Schema do
  describe 'inheritance' do
    it { expect(described_class).to be < ROM::Schema }
  end
end
