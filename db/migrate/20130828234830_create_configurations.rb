class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|

      t.timestamps
    end
  end
end
