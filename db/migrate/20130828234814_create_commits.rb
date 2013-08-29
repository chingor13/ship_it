class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :deployment_id
      t.string :sha
      t.string :message
      t.timestamps
    end
  end
end
