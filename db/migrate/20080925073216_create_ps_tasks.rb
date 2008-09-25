class CreatePsTasks < ActiveRecord::Migration
  def self.up
    create_table :ps_tasks do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ps_tasks
  end
end
