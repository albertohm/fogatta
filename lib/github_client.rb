
require "json"
require "net/https"

module GitHub

  module Helpers

    def https!(host = :api)
      Net::HTTP.new((host == :api ? "api." : "") + "github.com", 443).tap do |http|
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
    end

    def url_for_auth(url_to_return)
      "https://github.com/login/oauth/authorize?" + {
        client_id: GITHUB_CLIENT_ID,
        scope: "repo",
        redirect_uri: url_to_return
      }.to_query
    end

    def get_auth(code)

      # Get the access_token
      response = https!(:base).request(
        Net::HTTP::Post.new("/login/oauth/access_token").tap do |request|
          request.set_form_data(
            client_id: GITHUB_CLIENT_ID,
            client_secret: GITHUB_SECRET,
            format: "json",
            code: code)
        end)

      token = JSON.parse(response.body)['access_token']
      return false if token.blank?

      # Get user information
      response = https!.request(Net::HTTP::Get.new("/user?access_token=#{token}"))
      user = JSON.parse(response.body)

      { user: user, token: token }
    end

  end

  class User
    include Helpers

    def initialize(auth)
      @nickname = auth[:user]["login"]
      @token = auth[:token]
    end

    def orgs
      request = Net::HTTP::Get.new("/user/orgs")
      request["authorization"] = "bearer #@token"
      response = https!.request(request)

      JSON.parse(response.body).map {|org| org["login"] }
    end

    def repo_names
      orgs.flat_map do |org|
        request = Net::HTTP::Get.new("/orgs/#{org}/repos?type=member")
        request["authorization"] = "bearer #@token"
        response = https!.request(request)

        JSON.parse(response.body).map {|repo| repo["full_name"] }
      end
    end

  end

  extend Helpers

end
