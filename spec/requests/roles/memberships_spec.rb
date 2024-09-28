# frozen_string_literal: true

require 'rails_helper'

describe 'API Role - Memberships' do
  let(:json_response) { response.parsed_body }
  let(:headers) do
    { 'Accept' => 'application/json',
      'Content-Type' => 'application/json' }
  end

  describe 'GET /role/:role_id/memberships' do
    subject { get role_memberships_url(id), headers: headers }

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

      context 'when there is no Membership assigned' do
        it "returns the role's info and the Membership's" do
          subject

          expect(json_response['id']).to eq role.id
          expect(json_response['name']).to eq role.name
          expect(json_response['memberships']).to eq []
        end
      end

      context 'when there is at least one Membership assigned' do
        let!(:membership) { create(:membership, role: role) }

        it "returns the role's info and the Membership's" do
          subject

          expect(json_response['id']).to eq role.id
          expect(json_response['name']).to eq role.name
          expect(json_response['memberships'].first['team_id']).to eq membership.team_id
          expect(json_response['memberships'].first['user_id']).to eq membership.user_id
        end
      end
    end
  end
end
