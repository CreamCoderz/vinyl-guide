class RemoveRecords < ActiveRecord::Migration
  def self.up
    drop_table :records
  end

  def self.down
    create_table :records do |t|
      t.string :name
      t.string :description
      t.date :date

      t.timestamps
    end
  end
end
