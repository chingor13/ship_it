class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.integer :project_id
      t.string :name
      t.timestamps
    end
  end
end
