class CreatePsEvents < ActiveRecord::Migration
  def self.up
    create_table :ps_events do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :ps_events
  end
end
