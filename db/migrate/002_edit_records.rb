class EditRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :artist, :string
    add_column :records, :img_src, :string
    add_column :records, :producer, :string
    add_column :records, :band, :string
    add_column :records, :engineer, :string
    add_column :records, :studio, :string
  end

  def self.down
    remove_column :records, :artist
    remove_column :records, :img_src
    remove_column :records, :producer
    remove_column :records, :band
    remove_column :records, :engineer
    remove_column :records, :studio
  end
end


