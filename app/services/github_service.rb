require 'rest-client'

class GithubService
  def initialize(access_token)
    @access_token = access_token
  end

  def fetch_repositories
    begin
      response = RestClient.get('https://api.github.com/user/repos', {
        :Authorization => "Bearer #{@access_token}",
        :params => {:per_page => 10}
      })

      JSON.parse(response)
    rescue RestClient::Exception => e
      { 'error' => "Error fetching repositories: #{e.message}" }
    end
  end

  def fetch_members
    begin
      response = RestClient.get('https://api.github.com/orgs/github/members', {
        :Authorization => "Bearer #{@access_token}",
        :params => {:per_page => 10}
      })

      JSON.parse(response)
    rescue RestClient::Exception => e
      { 'error' => "Error fetching members: #{e.message}" }
    end
  end

  def fetch_organizations
    begin
      response = RestClient.get('https://api.github.com/user/orgs', {
        :Authorization => "Bearer #{@access_token}",
        :params => {:per_page => 10}
      })

      JSON.parse(response)
    rescue RestClient::Exception => e
      { 'error' => "Error fetching organizations: #{e.message}" }
    end
  end
end
