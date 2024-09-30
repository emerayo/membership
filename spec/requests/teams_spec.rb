# frozen_string_literal: true

require 'rails_helper'

describe 'API Teams' do
  let(:json_response) { response.parsed_body }
  let(:headers) do
    { 'Accept' => 'application/json',
      'Content-Type' => 'application/json' }
  end

  before do
    # Need to clear the cached properties
    Rails.cache.delete('teams/all')
  end

  describe 'GET /teams' do
    subject { get teams_url, headers: headers }

    context 'when there is no Team' do
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

    context 'when there is at least one Team' do
      let!(:team) { create(:team) }

      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns an array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response.size).to eq 1

        expect(json_response.first['id']).to eq team.id
        expect(json_response.first['name']).to eq team.name
      end
    end
  end

  describe 'GET /teams/:id' do
    subject { get team_url(id), headers: headers }

    context 'when the Team does not exist' do
      let(:id) { 1 }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the Team exists' do
      let!(:team) { create(:team) }
      let(:id) { team.id }

      context 'when Team has no member besides team lead' do
        it 'returns status code ok 200' do
          subject

          expect(response).to have_http_status(:success)
        end

        it "returns the team's info" do
          subject

          expect(json_response['id']).to eq team.id
          expect(json_response['name']).to eq team.name
          expect(json_response['teamLeadId']).to eq team.team_lead_id
        end
      end

      context 'when Team has members' do
        let!(:membership) { create(:membership, team: team) }

        it "returns the Team's info, its Memberships and status code ok 200" do
          subject

          expect(response).to have_http_status(:success)

          expect(json_response['id']).to eq team.id
          expect(json_response['name']).to eq team.name
          expect(json_response['teamLeadId']).to eq team.team_lead_id
          expect(json_response['teamMemberIds']).to be_an_instance_of(Array)
          expect(json_response['teamMemberIds'].first).to eq membership.user_id

          expect(json_response['memberships']).to be_an_instance_of(Array)
          expect(json_response['memberships'].first['user_id']).to eq membership.user_id
          expect(json_response['memberships'].first['role_id']).to eq membership.role_id
          expect(json_response['memberships'].first['role_name']).to eq membership.role_name
        end
      end
    end
  end
end
