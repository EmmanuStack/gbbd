require 'rest-client'

class GithubService
  def initialize(access_token)
    @access_token = access_token
    @organization_names = []
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

  def fetch_organizations
    begin
      response = RestClient.get("https://api.github.com/user/orgs", {
        :Authorization => "Bearer #{@access_token}",
        :params => {:per_page => 10}
      })
      parsed_response = JSON.parse(response)
      @organization_names = parsed_response.map{|x| x["login"]}
      parsed_response
    rescue RestClient::Exception => e
      { 'error' => "Error fetching organizations: #{e.message}" }
    end
  end

  def fetch_members
    begin
      return if @organization_names.empty?
      members = []
      @organization_names.each do |organization_name|
        response = RestClient.get("https://api.github.com/orgs/#{@organization_names.first}/members", {
          :Authorization => "Bearer #{@access_token}",
          :params => {:per_page => 10}
        })

        members.push(JSON.parse(response))
      end
      members.flatten
    rescue RestClient::Exception => e
      { 'error' => "Error fetching members: #{e.message}" }
    end
  end
end
