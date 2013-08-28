class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|

      t.timestamps
    end
  end
end
