class ReposController < ApplicationController
  def index
    organization = params[:organization]
    repo_rel = unless organization.nil?
      root = @client.root
      uri = { org: organization}
      query = { type: 'private' }
      root.rels[:organization_repositories]
    else
      uri = { }
      query = { }
      @user.rels[:repos]
    end
    @repos = get_repos(repo_rel, uri, query)
  end

  def show
    organization = params[:organization_id]
    @repo = @client.repo "#{organization}/#{params[:id]}"
    @rels = @repo.rels
    @branches = @repo.rels[:branches].get.data
  end

  private

  def get_repos(repo_rel, uri, query)
    template = repo_rel.get(uri: uri, query: query)
    next_rel = template.rels[:next]
    unless next_rel.nil?
      repos = get_repos(next_rel, uri, query)
    end
    return template.data + repos.to_a
  end
end
