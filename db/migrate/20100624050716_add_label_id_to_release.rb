class AddLabelIdToRelease < ActiveRecord::Migration
  def self.up
    add_column :releases, :label_id, :integer
  end

  def self.down
    remove_column :releases, :label_id
  end
end
