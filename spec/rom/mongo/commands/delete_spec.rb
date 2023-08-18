# frozen_string_literal: true

RSpec.describe ROM::Mongo::Commands::Delete do
  let(:dataset) { instance_double('DatasetInstance', filter: { 'id' => 42 }) }
  let(:relation_instance) do
    ::Class.new(ROM::Relation[:mongo]) do
      schema do
        attribute :id, ROM::Types::Integer
        attribute :a, ROM::Types::String
      end
    end.new(dataset)
  end
  let(:command_instance) { described_class.new(relation_instance, result: :one, input: true) }

  describe 'inheritance' do
    it { expect(described_class).to be < ROM::Commands::Delete }
  end

  describe 'Success' do
    subject(:command) { command_instance.call(attributes) }

    let(:attributes) { { a: '42', b: true } }

    before do
      allow(dataset)
        .to receive(:find)
        .with({ id: 42, **attributes }, { projection: { id: true, a: true } })
        .and_return(dataset)
      allow(dataset)
        .to receive_messages(first: {
                               'id' => 42,
                               'a' => '42',
                               'b' => true
                             }, delete_one: dataset, deleted_count: 1)
    end

    it { is_expected.to eq(id: 42, a: '42') }
  end

  describe 'Failure' do
    subject(:command) { command_instance.call(attributes) }

    let(:attributes) { { a: 1 } }

    before do
      allow(dataset)
        .to receive(:find)
        .with({ id: 42, **attributes }, { projection: { id: true, a: true } })
        .and_return(dataset)
      allow(dataset)
        .to receive_messages(first: {
                               'id' => 42,
                               'a' => '42',
                               'b' => true
                             }, delete_one: dataset, deleted_count: 0)
    end

    it { is_expected.to be_nil }
  end
end
