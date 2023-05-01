# frozen_string_literal: true

require "rest-client"

class GithubService
  def initialize(access_token)
    @access_token = access_token
    @organization_names = []
  end

  def fetch_repositories
    response = get_request("https://api.github.com/user/repos", { params: { per_page: 10 } })
    JSON.parse(response)
  rescue RestClient::Exception => e
    { "error" => "Error fetching repositories: #{e.message}" }
  end

  def fetch_organizations
    response = get_request("https://api.github.com/user/orgs", { params: { per_page: 10 } })
    parsed_response = JSON.parse(response)
    @organization_names = parsed_response.pluck("login")
    parsed_response
  rescue RestClient::Exception => e
    { "error" => "Error fetching organizations: #{e.message}" }
  end

  def fetch_members
    return if @organization_names.empty?

    members = []
    @organization_names.each do |organization_name|
      response = get_request("https://api.github.com/orgs/#{organization_name}/members", { params: { per_page: 10 } })
      members.push(JSON.parse(response))
    end

    members.flatten
  rescue RestClient::Exception => e
    { "error" => "Error fetching members: #{e.message}" }
  end

  private

  def get_request(url, options = {})
    headers = { Authorization: "Bearer #{@access_token}" }
    RestClient.get(url, headers.merge(options))
  end
end
