class CreateDeployOptions < ActiveRecord::Migration
  def change
    create_table :deploy_options do |t|

      t.timestamps
    end
  end
end
