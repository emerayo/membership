# frozen_string_literal: true

require 'rails_helper'

describe 'API Role' do
  let(:json_response) { response.parsed_body }
  let(:headers) do
    { 'Accept' => 'application/json',
      'Content-Type' => 'application/json' }
  end

  describe 'GET /roles' do
    subject { get roles_url, headers: headers }

    context 'when there is no Role' do
      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns a blank array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response).to eq([])
      end
    end

    context 'when there is at least one Role' do
      let!(:role) { create(:role) }

      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns an array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response.size).to eq 1

        expect(json_response.first['id']).to eq role.id
        expect(json_response.first['name']).to eq role.name
      end
    end
  end

  describe 'GET /search' do
    subject { get search_roles_url, params: { by_name: 'owner' }, headers: headers }

    context 'when there is no Role' do
      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns a blank array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response).to eq([])
      end
    end

    context 'when there is at least one Role and matches the params' do
      let!(:role) { create(:role, name: 'Product Owner') }

      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      context 'when there is no Membership assigned' do
        it "returns the Role's info but no Memberships" do
          subject

          expect(json_response.first['id']).to eq role.id
          expect(json_response.first['name']).to eq role.name
          expect(json_response.first['memberships']).to eq []
        end
      end

      context 'when there is at least one Membership assigned' do
        let!(:membership) { create(:membership, role: role) }

        it "returns the Role's info and the Memberships'" do
          subject

          expect(json_response.first['id']).to eq role.id
          expect(json_response.first['name']).to eq role.name
          expect(json_response.first['memberships'].first['team_id']).to eq membership.team_id
          expect(json_response.first['memberships'].first['user_id']).to eq membership.user_id
        end
      end
    end

    context 'when there is at least one Role but does not match the params' do
      let!(:role) { create(:role, name: 'Tester') }

      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns a blank array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response.size).to eq 0
      end
    end
  end

  describe 'GET /role/:id' do
    subject { get role_url(id), headers: headers }

    context 'when the Role does not exist' do
      let(:id) { 1 }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the Role exists' do
      let!(:role) { create(:role) }
      let(:id) { role.id }

      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it "returns the role's info" do
        subject

        expect(json_response['id']).to eq role.id
        expect(json_response['name']).to eq role.name
      end

      context 'when there is no Membership assigned' do
        it "returns the Role's info but no Memberships" do
          subject

          expect(json_response['id']).to eq role.id
          expect(json_response['name']).to eq role.name
          expect(json_response['memberships']).to eq []
        end
      end

      context 'when there is at least one Membership assigned' do
        let!(:membership) { create(:membership, role: role) }

        it "returns the Role's info and the Memberships'" do
          subject

          expect(json_response['id']).to eq role.id
          expect(json_response['name']).to eq role.name
          expect(json_response['memberships'].first['team_id']).to eq membership.team_id
          expect(json_response['memberships'].first['user_id']).to eq membership.user_id
        end
      end
    end
  end

  describe 'POST /roles' do
    subject { post roles_url, params: params.to_json, headers: headers }

    let(:valid_params) do
      {
        role: {
          name: Faker::Book.genre
        }
      }
    end

    let(:invalid_params) do
      {
        role: {
          name: nil
        }
      }
    end

    context 'with valid params' do
      let(:params) { valid_params }

      it 'creates a new Role and returns status code success 201' do
        expect { subject }.to change { Role.count }.by(1)
        expect(response).to have_http_status(:created)

        expect(json_response['name']).to eq params[:role][:name]
      end
    end

    context 'with missing params' do
      let(:params) { invalid_params }

      it 'returns status code unprocessable_entity 422' do
        expect { subject }.not_to(change { Role.count })
        expect(response.status).to eq 422
      end
    end
  end
end
