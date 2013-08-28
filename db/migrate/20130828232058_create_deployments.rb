class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|

      t.timestamps
    end
  end
end
