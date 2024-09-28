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
    end
  end
end
