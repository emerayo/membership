# frozen_string_literal: true

require 'rails_helper'

describe 'API Teams - Memberships' do
  let(:json_response) { response.parsed_body }
  let(:headers) do
    { 'Accept' => 'application/json',
      'Content-Type' => 'application/json' }
  end

  describe 'GET /teams/:team_id/memberships/:id' do
    subject { get team_membership_url(id, user_id), headers: headers }

    let!(:user) { create(:user) }

    let(:user_id) { user.id }

    context 'when the Team does not exist' do
      let!(:id) { 1 }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the Team exists but the User does not exist' do
      let!(:id) { create(:team).id }
      let(:user_id) { 1 }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the Membership exists' do
      let!(:team) { create(:team) }
      let!(:role) { create(:role, name: 'Product Owner') }
      let!(:membership) { create(:membership, team: team, user: user, role: role) }
      let(:id) { team.id }

      it "returns the Membership's infos" do
        subject

        expect(response).to have_http_status(:ok)
        expect(json_response['team_id']).to eq team.id
        expect(json_response['user_id']).to eq user_id
        expect(json_response['role_id']).to eq role.id
      end
    end
  end

  describe 'POST /teams/:team_id/memberships' do
    subject { post team_memberships_url(id), headers: headers, params: params.to_json }

    context 'when the Team does not exist' do
      let(:id) { 1 }
      let(:params) { {} }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the Team exists' do
      let!(:team) { create(:team) }
      let!(:role) { create(:role) }
      let!(:user) { create(:user) }
      let(:id) { team.id }

      let(:valid_params) do
        {
          membership: {
            user_id: user.id,
            role_id: role.id
          }
        }
      end

      let(:invalid_params) do
        {
          membership: {
            user_id: nil,
            role_id: role.id
          }
        }
      end

      context 'with valid params' do
        let(:params) { valid_params }

        it 'creates a new Membership and returns status code success 201' do
          expect { subject }.to change { Membership.count }.by(1)
          expect(response).to have_http_status(:created)

          expect(json_response['team_id']).to eq id
          expect(json_response['user_id']).to eq params[:membership][:user_id]
          expect(json_response['role_id']).to eq params[:membership][:role_id]
        end
      end

      context 'with invalid params' do
        let(:params) { invalid_params }

        it 'does not create a new Membershup returns status code unprocessable_entity 422' do
          expect { subject }.not_to(change { Role.count })
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /teams/:team_id/memberships/:id' do
    subject { patch team_membership_url(id, user_id), headers: headers, params: params.to_json }

    let!(:user) { create(:user) }

    let(:user_id) { user.id }
    let(:params) { {} }

    context 'when the Team does not exist' do
      let!(:id) { 1 }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the Team exists but the User does not exist' do
      let!(:id) { create(:team).id }
      let(:user_id) { 1 }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the Team exists' do
      let!(:team) { create(:team) }
      let!(:new_role) { create(:role, name: 'Product Owner') }
      let!(:membership) { create(:membership, team: team, user: user) }
      let(:id) { team.id }

      let(:valid_params) do
        {
          user_id: user.id,
          membership: {
            role_id: new_role.id
          }
        }
      end

      let(:invalid_params) do
        {
          membership: {
            user_id: user.id,
            role_id: nil
          }
        }
      end

      context 'with valid params' do
        let(:params) { valid_params }

        it "changes the Membership's role" do
          subject

          expect(response).to have_http_status(:ok)
          expect(json_response['team_id']).to eq team.id
          expect(json_response['user_id']).to eq user_id
          expect(json_response['role_id']).to eq new_role.id
        end
      end

      context 'with missing params' do
        let(:params) { invalid_params }

        it 'returns status code unprocessable_entity 422' do
          subject

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response).to eq({ 'errors' => { 'role' => ['must exist'] } })
        end
      end
    end
  end
end
