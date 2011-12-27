class PictureRemoveHasImage < ActiveRecord::Migration
  def self.up
    remove_column :pictures, :hasimage
  end

  def self.down
    add_column :pictures, :hasimage, :boolean
  end
end
