# frozen_string_literal: true

RSpec::Matchers.define(:exists_in_mongo_collection) do |collection_name|
  match do |document|
    collection(collection_name).find(document.to_h).to_a.one?
  end

  failure_message do
    "Document not found in collection: #{client.database.name}.#{collection_name}"
  end
end
