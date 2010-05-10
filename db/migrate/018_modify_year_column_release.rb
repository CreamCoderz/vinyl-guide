class ModifyYearColumnRelease < ActiveRecord::Migration
  def self.up
    change_column :releases, :year, :integer
  end

  def self.down
    change_column :releases, :year, :string
  end
end
