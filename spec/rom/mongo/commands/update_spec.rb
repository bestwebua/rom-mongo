# frozen_string_literal: true

RSpec.describe ROM::Mongo::Commands::Update do
  let(:dataset) { instance_double('DatasetInstance', filter: { 'id' => 42 }) }
  let(:command_instance) { described_class.new(relation_instance, result: :one, input: true) }

  describe 'inheritance' do
    it { expect(described_class).to be < ROM::Commands::Update }
  end

  describe 'Success' do
    subject(:command) { command_instance.call(attributes) }

    let(:relation_instance) do
      ::Class.new(ROM::Relation[:mongo]) do
        schema do
          attribute :id, ROM::Types::Integer
          attribute :a, ROM::Types::String
        end
      end.new(dataset)
    end
    let(:attributes) { { a: '42', b: true } }

    before do
      allow(dataset).to receive_messages(collection: dataset, modified_count: 1)
      allow(dataset).to receive(:update_one).with({ id: 42 }, attributes).and_return(dataset)
    end

    it { is_expected.to eq(id: 42, a: '42') }
  end

  describe 'Failure' do
    subject(:command) { command_instance.call(attributes) }

    let(:relation_instance) { ::Class.new(ROM::Relation[:mongo]).new(dataset) }
    let(:attributes) { { a: 1 } }

    before do
      allow(dataset).to receive_messages(collection: dataset, modified_count: 0)
      allow(dataset).to receive(:update_one).with({ id: 42 }, attributes).and_return(dataset)
    end

    it { is_expected.to be_nil }
  end
end
