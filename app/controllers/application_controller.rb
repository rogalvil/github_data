class ApplicationController < ActionController::Base
  before_action :set_client
  before_action :set_user

  def set_client
    @client = Octokit::Client.new(:access_token => '1927d58f57d968313a0bbdabed707fcff8d576a0')
  end

  def set_user
    @user = @client.user "rogalvil"
  end
end
