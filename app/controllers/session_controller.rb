class SessionController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    begin
      user = User.find_or_create_by(provider: auth_hash[:provider], uid: auth_hash[:uid]) do |user|
        user.name = auth_hash[:info][:name]
        user.token = auth_hash[:credentials][:token]
      end

      session[:user_id] = user.id
      GithubWorker.perform_async(user.id)
      redirect_to pages_overview_path
    rescue StandardError => e
      redirect_to root_path, alert: e.message
    end
  end


  def destroy
    reset_session

    redirect_to :root
  end

  private

  def auth_hash
    @auth_hash ||= request.env["omniauth.auth"]
  end
end