class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|

      t.timestamps
    end
  end
end
