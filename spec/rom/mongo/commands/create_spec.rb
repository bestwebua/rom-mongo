# frozen_string_literal: true

RSpec.describe ROM::Mongo::Commands::Create do
  let(:dataset) { instance_double('DatasetInstance') }
  let(:relation_instance) { ::Class.new(ROM::Relation[:mongo]).new(dataset) }
  let(:command_instance) { described_class.new(relation_instance, result: result_type, input: true) }

  describe 'inheritance' do
    it { expect(described_class).to be < ROM::Commands::Create }
  end

  describe 'Success' do
    subject(:command) { command_instance.call(*attributes) }

    before { allow(dataset).to receive(:insert).with(*attributes).and_return(ids) }

    context 'when result type is one' do
      let(:result_type) { :one }
      let(:ids) { [random_positive_number] }
      let(:attributes) { [{ a: 1 }] }

      it { is_expected.to eq(_id: ids.first, a: 1) }
    end

    context 'when result type is many' do
      let(:result_type) { :many }
      let(:ids) { [random_positive_number] }
      let(:attributes) { [{ a: 1 }, { a: 42 }] }

      it { is_expected.to eq([{ _id: ids[0], a: 1 }, { _id: ids[1], a: 42 }]) }
    end
  end

  describe 'Failure' do
    subject(:command) { command_instance.call(*attributes) }

    let(:result_type) { :one }
    let(:attributes) { [{ a: 1 }] }

    before { allow(dataset).to receive(:insert).with(*attributes).and_return([]) }

    it { is_expected.to be_nil }
  end
end
