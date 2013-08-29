require 'fileutils'
require 'git'

class Project < ActiveRecord::Base

  validates :name, :git_repo_url, presence: true

  has_many :branches, inverse_of: :project, dependent: :destroy
  has_many :environments, inverse_of: :project, dependent: :destroy
  has_many :deploy_options, inverse_of: :project, dependent: :destroy

  after_destroy :cleanup_workspace

  def cloned?
    File.directory?(workspace)
  end

  def underscored_name
    name.underscore
  end

  def workspace
    File.join(ShipIt.workspace, underscored_name)
  end

  def git
    @git ||= Git.open(workspace) if cloned?
  end

  def clone!
    puts "cloning: #{git_repo_url} -> #{workspace}"
    Git.clone(git_repo_url, underscored_name, path: ShipIt.workspace)
  rescue => e
    puts "error cloning: #{e.message}"
  end

  def pull!
    puts "pulling"
    git.fetch
    git.lib.send(:command, "rebase")
  end

  def poll!
    puts "in poll!"
    clone! unless cloned?
    pull!

    # sync branches and environments
    remotes = git.branches.remote.reject{|br| br.full.match("HEAD")}.map{|br| br.full.split("/").last}
    branches.each do |branch|
      branch.destroy unless remotes.include?(branch.name)
    end
    (remotes - branches.map(&:name)).each do |name|
      branches.create({:name => name})
    end

    envs = []
    Dir.glob(File.join(workspace, "config", "deploy", "*.rb")).each do |environment|
      envs << File.basename(environment).gsub(/.rb$/, "")
    end
    environments.each do |environment|
      environment.destroy unless envs.include?(environment.name)
    end
    (envs - environments.map(&:name)).each do |name|
      environments.create({:name => name})
    end
  rescue => e
    puts "error polling: #{e.message}"

    pp e.backtrace
  end

  protected

  def cleanup_workspace
    FileUtils.rm_rf workspace
  end

end
