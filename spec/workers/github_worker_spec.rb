require 'rails_helper'

RSpec.describe GithubWorker, type: :worker  do
  describe '#perform' do
    context 'when the user exists' do
      let(:user) { double('User', id: 1, token: '123456') }
      let(:github_service) { instance_double('GithubService') }
      let(:repositories) { [{ name: 'repo1' }, { name: 'repo2' }] }
      let(:organizations) { [{ login: 'org1' }, { login: 'org2' }] }
      let(:members) { [{ login: 'member1' }, { login: 'member2' }] }

      before do
        allow(User).to receive(:find).with(user.id).and_return(user)
        allow(GithubService).to receive(:new).with(user.token).and_return(github_service)
        allow(github_service).to receive(:fetch_repositories).and_return(repositories)
        allow(github_service).to receive(:fetch_organizations).and_return(organizations)
        allow(github_service).to receive(:fetch_members).and_return(members)
      end

      before(:each) do
        Redis.current.flushdb
        GithubWorker.new.perform(user.id)
      end

      it 'fetches the user data and stores it in Redis' do
        redis_data = eval(Redis.current.get("user:#{user.id}"))
        expect(redis_data[:repositories]).to eq(repositories)
        expect(redis_data[:organizations]).to eq(organizations)
        expect(redis_data[:members]).to eq(members)
      end
    end

    context 'when the user does not exist' do
      it 'raises an error' do
        expect {
          GithubWorker.new.perform(-1)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    context 'when error happens while connecting to Github' do
      let(:user) { double('User', id: 1, token: '123456') }
      let(:github_service) { instance_double('GithubService') }
      let(:repositories) { [{ name: 'repo1' }, { name: 'repo2' }] }
      let(:organizations) { [{ login: 'org1' }, { login: 'org2' }] }
      let(:members) { [{ login: 'member1' }, { login: 'member2' }] }

      before do
        allow(User).to receive(:find).with(user.id).and_return(user)
        allow(GithubService).to receive(:new).with(user.token).and_return(github_service)
        allow(github_service).to receive(:fetch_repositories).and_raise(StandardError)
      end

      it 'raises an error' do
        expect {
          GithubWorker.new.perform(user.id)
        }.to raise_error(StandardError)
      end
    end
  end
end
