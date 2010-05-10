class RenameColumnOnRecords < ActiveRecord::Migration
  def self.up
    rename_column :records, :name, :title
  end

  def self.down
    rename_column :records, :title, :name
  end
end
