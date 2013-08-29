class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.integer :branch_id
      t.integer :environment_id
      t.string :revision
      t.string :log_file
      t.boolean :success
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :created_by_id
      t.timestamps
    end
  end
end
