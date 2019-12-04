class BranchesController < ApplicationController
  before_action :set_repo

  def index
    @branches = @repo.rels[:branches].get.data
  end

  def show
    @repo_rels = @repo.rels
    @commits = @repo_rels[:commits].get.data
  end

  private
  def set_repo
    @repo = @client.repo "#{account_user}/#{params[:repo_id]}"
  end
end
