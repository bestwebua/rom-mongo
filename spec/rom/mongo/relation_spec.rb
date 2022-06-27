# frozen_string_literal: true

RSpec.describe ROM::Mongo::Relation do
  let(:dataset) { instance_double('DatasetInstance') }
  let(:relation_instance) do
    ::Class.new(described_class) do
      schema do
        attribute :id, ROM::Types::Integer.meta(primary_key: true)
        attribute :name, ROM::Types::String
        attribute :success, ROM::Types::Bool
      end
    end.new(dataset)
  end

  describe 'inheritance' do
    it { expect(described_class).to be < ROM::Relation }
  end

  describe '.view_methods' do
    subject(:view_methods) { ::Class.new(described_class).view_methods }

    it { is_expected.to include(:by_pk) }
  end

  describe '#by_pk' do
    subject(:by_pk) { relation_instance.by_pk(id) }

    let(:id) { random_positive_number }

    it do
      expect(dataset).to receive(:find).with(_id: id)
      by_pk
    end
  end

  describe '#count' do
    subject(:count) { relation_instance.count }

    it do
      expect(dataset).to receive(:count)
      count
    end
  end

  describe '#distinct' do
    subject(:distinct) { relation_instance.distinct(attribute) }

    let(:attribute) { random_word.to_sym }

    it do
      expect(dataset).to receive(:distinct).with(attribute)
      distinct
    end
  end
end
