class GithubWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    github_service = GithubService.new(user.token)
    Sidekiq.redis do |client|
      client.set(
        "user:#{user.id}",
        {
          :repositories => github_service.fetch_repositories,
          :organizations => github_service.fetch_organizations,
          :members => github_service.fetch_members
        })
    end
  end
end
