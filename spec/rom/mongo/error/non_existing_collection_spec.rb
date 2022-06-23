# frozen_string_literal: true

RSpec.describe ROM::Mongo::Error::NonExistingCollection do
  subject(:error_instance) { described_class.new(collection_namespace) }

  let(:collection_namespace) { 'some.namespace' }
  let(:error_context) { "Non existing collection: #{collection_namespace}" }

  it { expect(described_class).to be < ::RuntimeError }
  it { expect(error_instance).to be_an_instance_of(described_class) }
  it { expect(error_instance.to_s).to eq(error_context) }
end
