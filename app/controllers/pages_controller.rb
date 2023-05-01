class PagesController < ApplicationController
  def home
    reset_session
    redirect_to pages_overview_path if current_user
  end

  def overview
    if current_user
      @repositories, @organizations, @members, @error = fetch_github_info(current_user)
    else
      redirect_to root_path
    end
  end

  private

  def fetch_github_info(user)
    redis = Redis.new
    github_info = fetch_github_data(redis, user.id)

    [github_info[:repositories], github_info[:organizations], github_info[:members], nil]
  rescue Redis::BaseConnectionError, JSON::ParserError => e
    [[], [], [], e.message]
  end

  def fetch_github_data(redis, user_id)
    github_info = redis.get("user:#{user_id}")
    eval(github_info)
  end
end
