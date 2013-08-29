class Deployment < ActiveRecord::Base

  belongs_to :branch
  belongs_to :environment
  belongs_to :created_by, class_name: "User"
  has_many :commits, dependent: :destroy

  scope :pending, -> { where(started_at: nil) }
  scope :awaiting_termination, -> { where(user_terminated: true, finished_at: nil) }
  
  scope :in_progress, -> { where("started_at is not null and finished_at is null") }

  delegate :project, to: :environment

  before_validation :set_revision, on: :create
  before_validation :set_created_by, on: :create
  before_create :build_pending_commits
  after_destroy :destroy_log

  def started?
    started_at.present?
  end

  def completed?
    finished_at.present?
  end
  
  def failed?
    completed? && !success?
  end
  
  def short_revision
    revision.andand[0...8]
  end

  def percent_complete
    return 100 if completed?
    return 0 unless started?
    last_duration = environment.deployments.last_successfull_deployment.andand.duration
    return nil unless last_duration
    duration * 100 / last_duration
  end

  def duration
    return nil unless started?
    (finished_at || Time.now).to_i - started_at.to_i
  end

  def status
    if !started?
      return "pending"
    elsif !completed?
      # still running
      if user_terminated?
        return "awaiting termination"
      else
        return "in progress"
      end
    elsif success?
      return "succeeded"
    elsif user_terminated?
      return "terminated"
    else
      return "failed"
    end
  end

  def log
    # read log file
    File.read(log_file) if log_file.present?
  end
  
  def terminate!
    update_attributes(user_terminated: true)
  end

  def deploy!
    log_file = File.join(ShipIt.log_dir, "#{branch.name}-#{environment.name}-#{Time.now.strftime("%Y%m%d%H%M%S")}.log")
    update_attributes(log_file: log_file)

    deploy_options = ["branch=#{revision}"] + project.deploy_options.map{|option| "#{option.name}=#{option.read_attribute(:value)}"}
    deploy_options = deploy_options.map{|str| "-S #{str}"}.join(" ")

    command = "bundle install --deployment --without development test && bundle exec cap #{environment.name} #{deploy_options} deploy:migrations"
    #command = "bundle exec cap #{environment.name} #{deploy_options} deploy:migrations"
    success = run_command(command, log_file)

    update_attributes(finished_at: Time.now, success: success)
  end

  protected

  def run_command(command, log_file)
    pid = nil
    
    puts "running command: #{command}"

    Bundler.with_clean_env do
      new_env = {"HOME" => ENV["HOME"]}
      pid = Process.spawn(new_env, command, [:out, :err] => [log_file, "w"], chdir: project.workspace)

      Process.wait(pid)
    end
    
    status = $?
    
    return (status.exitstatus == 0)
    
  rescue Exception => e
    puts "deploy error: #{e.message}"
    Process.kill("INT", pid) if pid

    return false
  end

  def set_revision
    self.revision ||= branch.current_revision
  end

  def set_created_by
    self.created_by ||= User.current
  end

  def build_pending_commits
    environment.pending_changes(branch).andand.each do |commit|
      commits.build({
        sha: commit.sha,
        message: commit.message,
      })
    end
  end

  def destroy_log
    File.unlink(log_file) if log_file.present? && File.exists?(log_file)
  end

end
