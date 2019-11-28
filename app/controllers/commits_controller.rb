class CommitsController < ApplicationController
  before_action :set_repo

  def index
    template = @repo.rels[:commits].get
    @commits = get_commits(template)
  end

  def master_from_initial
    template = @repo.rels[:commits].get
    all_commits = get_commits(template)
    first_commit = get_first_commit(all_commits.reverse)
    @commits = get_master_commits(all_commits, first_commit)+[first_commit]
  end

  def master_from_last
  end

  private

  def get_master_commits(commits, master_commit)
    next_commit = commits.detect{|w| w.parents.count == 2 && w.parents.select { |p| p[:sha] == master_commit.sha }.count > 0 }
    #next_commit = commit.first.parents.select { |p| p[:sha] == master_commit.sha }
    #@commits.map { |c| c if c.parents.select { |p| p[:sha] == master_commit.sha }.count > 0 }.compact.count

    unless next_commit.nil?
      master_commits = get_master_commits(commits, next_commit)
    end
    return ([next_commit] + master_commits.to_a).compact
  end

  def get_commits(template)
    next_rel = template.rels[:next]
    unless next_rel.nil?
      commits = get_commits(next_rel.get)
    end
    return template.data + commits.to_a
  end

  def get_first_commit(commits)
    commits.detect{|w| w.parents.empty? }
  end

  def set_repo
    @repo = @client.repo "rogalvil/#{params[:repo_id]}"
  end
end
