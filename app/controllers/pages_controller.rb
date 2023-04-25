class PagesController < ApplicationController
  def home
    return redirect_to :pages_overview if current_user
  end

  def overview
    return redirect_to :root unless current_user

    github_service = GithubService.new(current_user.token)
    @repositories = github_service.fetch_repositories
    @members = github_service.fetch_members
    @organizations = github_service.fetch_organizations
  end

end
