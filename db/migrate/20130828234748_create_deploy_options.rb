class CreateDeployOptions < ActiveRecord::Migration
  def change
    create_table :deploy_options do |t|
      t.integer :project_id
      t.string :name
      t.string :value
      t.boolean :visible, default: true
      t.timestamps
    end
  end
end
