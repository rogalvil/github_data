class ReposController < ApplicationController
  def index
    @repos = @user.rels[:repos].get.data
  end

  def show
    @repo = @client.repo "rogalvil/#{params[:id]}"
    @rels = @repo.rels
    @branches = @repo.rels[:branches].get.data
    #@merges = @repo.rels[:merges].get.data
    @commits = @repo.rels[:commits].get.data
  end
end
