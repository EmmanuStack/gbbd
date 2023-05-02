class GithubWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    github_service = GithubService.new(user.token)
    github_data = {}
    github_data[:repositories] = github_service.fetch_repositories
    github_data[:organizations] = github_service.fetch_organizations
    github_data[:members] = github_service.fetch_members
    Sidekiq.redis do |client|
      client.set("user:#{user.id}", YAML.dump(github_data))
    end
  end
end
