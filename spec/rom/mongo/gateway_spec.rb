# frozen_string_literal: true

RSpec.describe ROM::Mongo::Gateway do
  let(:gateway_instance) { described_class.new(client) }
  let(:client) { instance_double('MongoClientInstance') }
  let(:mongo_collection) { instance_double('MongoCollectionClass') }
  let(:dataset_class) { class_double('DatasetClass') }
  let(:dataset_instance) { instance_double('DatasetInstance') }
  let(:field_name) { random_word.to_sym }

  describe 'inheritance' do
    it { expect(described_class).to be < ROM::Gateway }
  end

  describe '#datasets' do
    it { expect(gateway_instance.datasets).to be_an_instance_of(::Hash) }
  end

  describe '#dataset' do
    it 'addes new dataset' do
      expect(client)
        .to receive(:[])
        .with(field_name)
        .and_return(mongo_collection)
      expect(dataset_class)
        .to receive(:new)
        .with(mongo_collection)
        .and_return(dataset_instance)
      expect(gateway_instance.dataset(field_name, dataset_class)).to eq(dataset_instance)
      expect(gateway_instance.datasets).to include(field_name => dataset_instance)
    end
  end

  describe '#dataset?' do
    context 'when dataset exists' do
      before { gateway_instance.datasets[field_name] = true }

      it { expect(gateway_instance.dataset?(field_name)).to be(true) }
    end

    context 'when non existing dataset' do
      it { expect(gateway_instance.dataset?(field_name)).to be(false) }
    end
  end

  describe '#[]' do
    context 'when dataset exists' do
      before { gateway_instance.datasets[field_name] = true }

      it { expect(gateway_instance[field_name]).to be(true) }
    end

    context 'when non existing dataset' do
      it { expect(gateway_instance[field_name]).to be_nil }
    end
  end

  ROM::Lint::Gateway.each_lint do |field_name, linter|
    it field_name do
      expect(linter.new(:mongo, described_class, :mongo_url).lint(field_name)).to be(true)
    end
  end
end
