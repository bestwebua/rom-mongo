# frozen_string_literal: true

RSpec.describe ROM::Mongo, type: :integration do
  describe 'integration' do
    let(:container) do
      ROM.container(:mongo, client) do |config|
        config.relation(:users) do
          schema(:users) do
            attribute :_id, ROM::Types.Nominal(BSON::ObjectId)
            attribute :email, ROM::Types::String
            attribute :rating, ROM::Types::Integer
            attribute :status, ROM::Types::Bool
            attribute :orders?, ROM::Types::Array
          end
        end
      end
    end

    let(:user_repository) do
      ::Class.new(ROM::Repository[:users]) do
        commands(:create, :delete, update: :by_pk)

        def find(**options)
          users.find(options).one
        end
      end.new(container)
    end

    describe 'Gateway' do
      let(:gateway) { container.gateways[user_repository.users.gateway] }

      describe '#dataset' do
        subject(:dataset) { gateway.dataset?(dataset_name) }

        context 'when dataset exists' do
          let(:dataset_name) { :users }

          it { is_expected.to be(true) }
        end

        context 'when dataset does not exist' do
          let(:dataset_name) { :mooses }

          it { is_expected.to be(false) }
        end
      end
    end

    describe 'Relation' do
      let(:relation) { user_repository.users }
      let(:email) { random_email }
      let!(:user) do
        user_repository.create(
          {
            email: email,
            rating: random_positive_number,
            status: random_status
          }
        )
      end

      describe '#by_pk' do
        subject(:relation_by_pk) { relation.by_pk(user._id) }

        it 'returns documents matched by pk' do
          expect(relation_by_pk.to_a).to eq([user])
        end
      end

      describe '#count' do
        subject(:count) { relation.count }

        it { is_expected.to eq(collection_size(:users)) }
      end

      describe '#distinct' do
        subject(:distinct) { relation.distinct(:email) }

        it { is_expected.to eq([email]) }
      end
    end

    describe 'Commands' do
      describe '#create' do
        subject(:new_user) { user_repository.create(user_attributes) }

        let(:email) { random_email }
        let(:rating) { random_positive_number }
        let(:status) { random_status }
        let(:user_attributes) { { email: email, rating: rating, status: status } }

        it 'creates one new document' do
          expect { new_user }.to change { collection_size(:users) }.from(0).to(1)
          expect(new_user).to exists_in_mongo_collection(:users)
          expect(new_user._id).to be_an_instance_of(BSON::ObjectId)
          expect(new_user.email).to eq(email)
          expect(new_user.rating).to eq(rating)
          expect(new_user.status).to eq(status)
          expect(new_user.orders).to be_nil
        end
      end

      describe '#update' do
        subject(:updated_user) do
          user_repository.update(user_id, { email: new_email, rating: new_rating, status: new_status })
        end

        let(:email) { random_email }
        let(:rating) { random_positive_number }
        let(:status) { random_status }
        let(:new_email) { random_email }
        let(:new_rating) { random_positive_number }
        let(:new_status) { random_status }
        let!(:user) { user_repository.create({ email: email, rating: rating, status: status }) }
        let(:user_id) { user._id }

        it 'updates one document matched by primary key' do
          expect { updated_user }.not_to(change { collection_size(:users) })
          expect(updated_user).to exists_in_mongo_collection(:users)
          expect(updated_user._id).to eq(user_id)
          expect(updated_user.email).to eq(new_email)
          expect(updated_user.rating).to eq(new_rating)
          expect(updated_user.status).to eq(new_status)
          expect(updated_user.orders).to be_nil
          expect(user_repository.find(_id: user_id)).to eq(updated_user)
        end
      end

      describe '#delete' do
        subject(:deleted_user) { user_repository.delete(_id: user_id) }

        let(:email) { random_email }
        let(:rating) { random_positive_number }
        let(:status) { random_status }
        let!(:user) { user_repository.create({ email: email, rating: rating, status: status }) }
        let(:user_id) { user._id }

        it 'deletes one document matched by primary key' do
          expect { deleted_user }.to change { collection_size(:users) }.from(1).to(0)
          expect(deleted_user).not_to exists_in_mongo_collection(:users)
          expect(deleted_user._id).to eq(user_id)
          expect(deleted_user.email).to eq(email)
          expect(deleted_user.rating).to eq(rating)
          expect(deleted_user.status).to eq(status)
          expect(deleted_user.orders).to be_nil
        end
      end
    end
  end
end
