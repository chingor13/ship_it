class User < ActiveRecord::Base
  has_many :deployments

  class << self
    attr_accessor :current

    def find_or_create_from_auth_hash(auth_hash)
      user = find_by_id(auth_hash["uid"])
      return user if user

      user = create({
        :id => auth_hash["uid"],
        :name => auth_hash["info"]["name"],
        :email_address => auth_hash["info"]["email"],
      })
    end
  end
end
