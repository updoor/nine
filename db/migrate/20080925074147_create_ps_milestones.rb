class CreatePsMilestones < ActiveRecord::Migration
  def self.up
    create_table :ps_milestones do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ps_milestones
  end
end
