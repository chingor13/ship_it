class Environment < ActiveRecord::Base

  belongs_to :project
  has_many :deployments, dependent: :destroy
  has_one :last_deployment, order: "id desc", class_name: "Deployment"
  has_one :last_successful_deployment, order: "id desc", class_name: "Deployment", conditions: {success: true}

  validates :name, presence: true, uniqueness: {scope: :project_id}

  def current_branch
    last_successful_deployment.andand.branch
  end

  def pending_changes(branch = nil)
    branch ||= current_branch
    return nil unless current_branch

    @pending_changes ||= begin
      commits = []
      current_rev = last_successful_deployment.revision
      latest_rev = branch.current_revision

      project.git.log.between(current_rev, latest_rev).each do |commit|
        commits << commit
      end
      commits
    end
  end
end
