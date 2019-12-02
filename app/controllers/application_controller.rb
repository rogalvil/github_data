class ApplicationController < ActionController::Base
  before_action :set_client
  before_action :set_user

  def set_client
    @client = Octokit::Client.new(:access_token => '0dfe95fcd7723dcd0593b59171b1ee223d8ca7b1')
  end

  def set_user
    @user = @client.user "rogalvil"
  end
end
