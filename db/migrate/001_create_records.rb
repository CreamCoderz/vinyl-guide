class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.string :name
      t.string :description
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end