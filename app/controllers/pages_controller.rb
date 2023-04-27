class PagesController < ApplicationController
  def home
    reset_session
    return redirect_to :pages_overview if current_user
  end

  def overview
    begin
      return redirect_to :root unless current_user
      redis = Redis.new
      github_info = redis.get("user:#{current_user.id}")
      github_info = eval(github_info)
      @repositories = github_info[:repositories]
      @organizations = github_info[:organizations]
      @members = github_info[:members]
    rescue StandardError => e
      @error = e.message
    end
  end

end
