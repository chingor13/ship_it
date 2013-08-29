class Commit < ActiveRecord::Base

  belongs_to :deployment

  validates :deployment, presence: true
  validates :sha, presence: true

end
