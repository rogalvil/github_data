class ApplicationController < ActionController::Base
  before_action :set_client
  before_action :set_user

  def set_client
    @client = Octokit::Client.new(
      #access_token: '173c2794fd1c4f74bcdf67e08e9de0917129a2c9'
      access_token: 'bffe52767d7681370c7a6b6889f15d2f9a108b44'
    )
  end

  def set_user
    @user = @client.user account_user
  end

  def account_user
    @client.root.rels[:current_user].get.data.login
  end
end
