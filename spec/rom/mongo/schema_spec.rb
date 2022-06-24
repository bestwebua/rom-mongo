# frozen_string_literal: true

RSpec.describe ROM::Mongo::Schema do
  describe 'inheritance' do
    it { expect(described_class).to be < ROM::Schema }
  end

  describe '#to_output_hash' do
    subject(:to_output_hash) { schema.to_output_hash.call(attributes) }

    let(:schema) do
      ::Class.new(ROM::Relation[:mongo]).schema do
        attribute :id, ROM::Types::Integer.meta(primary_key: true)
        attribute :name, ROM::Types::String
        attribute :success, ROM::Types::Bool
      end.call
    end

    let(:attributes) do
      {
        'id' => random_positive_number,
        'name' => random_word,
        'success' => [true, false].sample
      }
    end

    it 'matches and symbolizes keys with schema' do
      expect(schema.primary_key).to include(schema[:id])
      expect(to_output_hash).to eq(attributes.transform_keys(&:to_sym))
    end
  end
end
