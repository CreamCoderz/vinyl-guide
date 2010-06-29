class ReplaceLabelColumnInReleases < ActiveRecord::Migration
  def self.up
    remove_column :releases, :label
  end

  def self.down
    add_column :releases, :label, :string    
  end
end
