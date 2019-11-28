class ApplicationController < ActionController::Base
  before_action :set_client
  before_action :set_user

  def set_client
    @client = Octokit::Client.new(:access_token => '7e14382fd469d939e7bbcf2c48b5798ae77844b0')
  end

  def set_user
    @user = @client.user "rogalvil"
  end
end
