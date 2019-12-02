class ReposController < ApplicationController
  def index
    @repos = @user.rels[:repos].get.data

    template = @user.rels[:repos].get
    @repos = get_repos(template)
  end

  def show
    @repo = @client.repo "rogalvil/#{params[:id]}"
    @rels = @repo.rels
    @branches = @repo.rels[:branches].get.data
    @repos = @repo.rels[:repos].get.data
  end

  private

  def get_repos(template)
    next_rel = template.rels[:next]
    unless next_rel.nil?
      repos = get_repos(next_rel.get)
    end
    return template.data + repos.to_a
  end
end
