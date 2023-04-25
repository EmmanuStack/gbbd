require 'rails_helper'
require 'rest-client'

describe GithubService do
  let!(:access_token) { 'some_access_token' }
  let!(:github_service) { GithubService.new(access_token) }

  describe '#fetch_repositories' do
    context 'when Github returns an error' do
      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/user/repos',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_raise(RestClient::Exception)
      end

      it 'raises an exception when Github returns an error' do
        expect(github_service.fetch_repositories).to eq({"error"=>"Error fetching repositories: RestClient::Exception"})

      end
    end

    context 'when the call to Github fails' do
      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/user/repos',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_raise(SocketError.new('Failed to connect'))
      end

      it 'raises an exception' do
        expect { github_service.fetch_repositories }.to raise_error(SocketError)
      end
    end
    context 'when the call to Github succeeds' do

      let(:response) { '[{"name": "repo1"}, {"name": "repo2"}]' }

      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/user/repos',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_return(response)
      end

      it 'returns a list of repositories' do
        expect(github_service.fetch_repositories).to eq([{ 'name' => 'repo1' }, { 'name' => 'repo2' }])
      end
    end
  end


  describe '#fetch_members' do
    context 'when Github returns an error' do
      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/orgs/github/members',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_raise(RestClient::Exception)
      end

      it 'raises an exception when Github returns an error' do
        expect(github_service.fetch_members).to eq({"error"=>"Error fetching members: RestClient::Exception"})

      end
    end

    context 'when the call to Github fails' do
      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/orgs/github/members',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_raise(SocketError.new('Failed to connect'))
      end

      it 'raises an exception' do
        expect { github_service.fetch_members }.to raise_error(SocketError)
      end
    end
    context 'when the call to Github succeeds' do
      let(:response) { '[{"login": "user1"}, {"login": "user2"}]' }

      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/orgs/github/members',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_return(response)
      end

      it 'returns a list of members in the "github" organization' do
        expect(github_service.fetch_members).to eq([{ 'login' => 'user1' }, { 'login' => 'user2' }])
      end
    end
  end

  describe '#fetch_organizations' do
    context 'when Github returns an error' do
      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/user/orgs',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_raise(RestClient::Exception)
      end

      it 'raises an exception when Github returns an error' do
        expect(github_service.fetch_organizations).to eq({"error"=>"Error fetching organizations: RestClient::Exception"})

      end
    end

    context 'when the call to Github fails' do
      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/user/orgs',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_raise(SocketError.new('Failed to connect'))
      end

      it 'raises an exception' do
        expect { github_service.fetch_organizations }.to raise_error(SocketError)
      end
    end
    context 'when the call to Github succeeds' do
      let(:response) { '[{"login": "org1"}, {"login": "org2"}]' }

      before do
        allow(RestClient).to receive(:get).with(
          'https://api.github.com/user/orgs',
          {
            Authorization: "Bearer #{access_token}",
            params: { per_page: 10 }
          }
          ).and_return(response)
      end

      it 'returns a list of organizations the user belongs to' do
        expect(github_service.fetch_organizations).to eq([{ 'login' => 'org1' }, { 'login' => 'org2' }])
      end
    end
  end
end
