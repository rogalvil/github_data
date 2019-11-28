class BranchesController < ApplicationController
  before_action :set_repo

  def index
    @branches = @repo.rels[:branches].get.data
  end

  def show
    @repo_rels = @repo.rels
    #@branches = @repo.rels[:branches].get.data
    #@merges = @repo.rels[:merges].get.data
    @commits = @repo_rels[:commits].get.data
    

    #@commit_rels = @commits.rels
  end

  def commits
    @commits = @repo.rels[:commits].get.data
  end

  def pulls
    @pulls = @repo.rels[:pulls].get.data
  end

  private
  def set_repo
    @repo = @client.repo "rogalvil/#{params[:repo_id]}"
  end
end
