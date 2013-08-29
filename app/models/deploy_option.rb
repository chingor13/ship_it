class DeployOption < ActiveRecord::Base

  belongs_to :project

  validates :name, presence: true
  validates :value, presence: true

  def value
    visible? ? read_attribute(:value) : "(not visible)"
  end
end
