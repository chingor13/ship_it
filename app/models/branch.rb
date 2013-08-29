class Branch < ActiveRecord::Base

  belongs_to :project
  has_many :deployments, dependent: :destroy
  validates :name, presence: true, uniqueness: {scope: :project_id}

  def current_revision
    project.git.revparse("remotes/origin/#{name}")
  end
  
  def last_commit
    @last_commit ||= project.git.log.between("#{current_revision}^", current_revision).first
  end

end
