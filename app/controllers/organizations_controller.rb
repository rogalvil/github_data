class OrganizationsController < ApplicationController
  def show
    @organization = params[:id]
    uri = { }
    root = @client.root

    repo_rel = if @organization.nil? || @organization == account_user
      uri = { user: @organization}
      root.rels[:current_user_repositories]
    else
      uri = { org: @organization}
      root.rels[:organization_repositories]
    end
    @private_repos = get_repos(repo_rel, uri, { type: 'private' })
    @public_repos = get_repos(repo_rel, uri, { type: 'public' })
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
