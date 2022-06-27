# frozen_string_literal: true

RSpec.describe ROM::Mongo::Dataset do
  let(:collection) { instance_double('MongoCollectionInstance') }
  let(:collection_view) { instance_double('MongoCollectionViewInstance') }
  let(:dataset_instance) { described_class.new(collection) }

  describe '#collection' do
    it { expect(dataset_instance.collection).to eq(collection) }
  end

  describe '#find' do
    let(:filter_options) { random_filter_options }
    let(:projection) { random_projection_options }

    context 'with default position parameters' do
      it 'returns mongo collection view' do
        expect(collection)
          .to receive(:find)
          .with({}, {})
          .and_return(collection_view)
        expect(dataset_instance.find).to eq(collection_view)
      end
    end

    context 'with custom position parameters' do
      it 'returns mongo collection view' do
        expect(collection)
          .to receive(:find)
          .with(filter_options, projection)
          .and_return(collection_view)
        expect(dataset_instance.find(filter_options, projection)).to eq(collection_view)
      end
    end
  end

  describe '#sort' do
    let(:filter_options) { { random_word.to_sym => 1 } }

    it 'returns mongo collection view' do
      expect(collection)
        .to receive(:find)
        .with({}, {})
        .and_return(collection_view)
      expect(collection_view)
        .to receive(:sort)
        .with(filter_options)
        .and_return(collection_view)
      expect(dataset_instance.sort(filter_options)).to eq(collection_view)
    end
  end

  describe '#limit' do
    let(:count) { random_positive_number }

    it 'returns mongo collection view' do
      expect(collection)
        .to receive(:find)
        .with({}, {})
        .and_return(collection_view)
      expect(collection_view)
        .to receive(:limit)
        .with(count)
        .and_return(collection_view)
      expect(dataset_instance.limit(count)).to eq(collection_view)
    end
  end

  describe '#skip' do
    let(:count) { random_positive_number }

    it 'returns mongo collection view' do
      expect(collection)
        .to receive(:find)
        .with({}, {})
        .and_return(collection_view)
      expect(collection_view)
        .to receive(:skip)
        .with(count)
        .and_return(collection_view)
      expect(dataset_instance.skip(count)).to eq(collection_view)
    end
  end

  describe '#insert' do
    subject(:insert) { dataset_instance.insert(*attributes) }

    context 'when inserts one document' do
      let(:attributes) { random_dataset(size: 1) }
      let(:inserted_ids) { [random_bson_object_id.to_s] }
      let(:insert_result) { instance_double('MongoOperationInsertResultInstance') }

      it 'returns inserted ids collection' do
        expect(collection)
          .to receive(:insert_one)
          .with(*attributes)
          .and_return(insert_result)
        expect(insert_result)
          .to receive(:inserted_ids)
          .and_return(inserted_ids)
        expect(insert).to eq(inserted_ids)
      end

      context 'when inserts more then one document' do
        let(:attributes) { random_dataset(size: 2) }
        let(:inserted_ids) { ::Array.new(2) { random_bson_object_id.to_s } }
        let(:insert_result) { instance_double('MongoOperationInsertResultInstance') }

        it 'returns inserted ids collection' do
          expect(collection)
            .to receive(:insert_many)
            .with(attributes)
            .and_return(insert_result)
          expect(insert_result)
            .to receive(:inserted_ids)
            .and_return(inserted_ids)
          expect(insert).to eq(inserted_ids)
        end
      end
    end
  end

  describe '#count' do
    let(:count) { random_positive_number }

    it 'returns mongo collection view' do
      expect(collection)
        .to receive(:find)
        .with({}, {})
        .and_return(collection_view)
      expect(collection_view)
        .to receive(:count)
        .and_return(count)
      expect(dataset_instance.count).to eq(count)
    end
  end

  describe '#distinct' do
    let(:distinct_attribute) { random_word.to_sym }
    let(:uniq_values_by_field) { ::Array.new(random_positive_number) { random_word } }

    it 'returns mongo collection view' do
      expect(collection)
        .to receive(:find)
        .with({}, {})
        .and_return(collection_view)
      expect(collection_view)
        .to receive(:distinct)
        .with(distinct_attribute)
        .and_return(uniq_values_by_field)
      expect(dataset_instance.distinct(distinct_attribute)).to eq(uniq_values_by_field)
    end
  end

  describe '#map' do
    it 'returns mapped collection' do
      expect(collection)
        .to receive(:find)
        .with({}, {})
        .and_return(%w[a b c])
      expect(dataset_instance.map(&:to_sym)).to eq(%i[a b c])
    end
  end
end
