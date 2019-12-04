class CommitsController < ApplicationController
  before_action :set_repo

  def index
    template = @repo.rels[:commits].get
    @commits = get_commits(template)
  end

  def master
    template = @repo.rels[:commits].get
    all_commits = get_commits(template)
    first_commit = get_first_commit(all_commits.reverse)
    # Este metodo es siguiendo los parents pero hay un problema cuando hay commits a master no hechos por un PR
    #@commits = get_master_commits(all_commits, first_commit)+[first_commit]
    # este metodo asume que el commiter es GitHub pero el problema es que no tomara en cuanta un merge manual a master por parte de otro usuario
    @commits = get_master_commits_by_committer(all_commits, "GitHub", params[:from_at], params[:to_at])
    #next_commit = commits.detect{|w| w.parents.count == 2 && w.commit.committer.name == "GitHub" }
  end

  def master_from_last
  end

  private

  def get_master_commits_by_committer(commits, committer, from_at, to_at)
    filter_commits = commits.select { |c| c.commit.committer.email == "noreply@github.com" }
    filter_commits = filter_commits.select { |c| c.commit.committer.date >= from_at} unless from_at.nil?
    filter_commits = filter_commits.select { |c| c.commit.committer.date <= to_at} unless to_at.nil?
    filter_commits
  end

  def get_master_commits(commits, master_commit)
    next_commit = commits.detect{|w| w.parents.count == 2 && w.parents.select { |p| p[:sha] == master_commit.sha }.count > 0 }
    next_commit = commits.detect{|w| w.parents.count == 1 && w.parents.select { |p| p[:sha] == master_commit.sha }.count > 0 } if next_commit.nil?
    unless next_commit.nil?
      master_commits = get_master_commits(commits, next_commit)
    end
    return (master_commits.to_a + [next_commit]).compact
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
    @repo = @client.repo "#{params[:organization_id]}/#{params[:repo_id]}"
  end
end
