class HomeController < ApplicationController
  def index;
    @account_user = account_user
    @organizations = @client.root.rels[:user_organizations].get.data
  end
end
