# frozen_string_literal: true

require 'rails_helper'

describe 'API Users' do
  let(:json_response) { response.parsed_body }
  let(:headers) do
    { 'Accept' => 'application/json',
      'Content-Type' => 'application/json' }
  end

  before do
    # Need to clear the cached properties
    Rails.cache.delete('users/all')
  end

  describe 'GET /users' do
    subject { get users_url, headers: headers }

    context 'when there is no User' do
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

    context 'when there is at least one User' do
      let!(:user) { create(:user) }

      it 'returns status code ok 200' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns an array' do
        subject

        expect(json_response).to be_an_instance_of(Array)
        expect(json_response.size).to eq 1

        expect(json_response.first['id']).to eq user.id
        expect(json_response.first['displayName']).to eq user.display_name
      end
    end
  end

  describe 'GET /users/:id' do
    subject { get user_url(id), headers: headers }

    context 'when the User does not exist' do
      let(:id) { 1 }

      it 'returns status code not_found 404' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the User exists' do
      let!(:user) { create(:user) }
      let(:id) { user.id }

      it "returns the user's info and status code ok 200" do
        subject

        expect(response).to have_http_status(:success)

        expect(json_response['id']).to eq user.id
        expect(json_response['displayName']).to eq user.display_name
        expect(json_response['firstName']).to eq user.first_name
        expect(json_response['lastName']).to eq user.last_name
        expect(json_response['avatarUrl']).to eq user.avatar_url
        expect(json_response['location']).to eq user.location
      end

      context 'when User has a Membership' do
        let(:role) { create(:role) }
        let!(:membership) { create(:membership, user: user, role: role) }

        it "returns the User's info, its Memberships' status code ok 200" do
          subject

          expect(response).to have_http_status(:success)

          expect(json_response['memberships'].first['team_id']).to eq membership.team_id
          expect(json_response['memberships'].first['role_id']).to eq role.id
          expect(json_response['memberships'].first['role_name']).to eq role.name
        end
      end

      context 'when User is a Team Lead of one Team' do
        let!(:team) { create(:team, team_lead: user) }

        it "returns the User's info, its Leading Team's and status code ok 200" do
          subject

          expect(response).to have_http_status(:success)

          expect(json_response['leading_teams'].first['id']).to eq team.id
          expect(json_response['leading_teams'].first['name']).to eq team.name
        end
      end
    end
  end
end
