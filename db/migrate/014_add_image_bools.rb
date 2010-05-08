require 'pp'
require 'set'

class AddImageBools < ActiveRecord::Migration

  def self.up
    add_column(:ebay_items, :hasimage, :boolean, :default => false)
    add_column(:pictures, :hasimage, :boolean, :default => false)
  end

  def self.down
    remove_column(:ebay_items, :hasimage)
    remove_column(:pictures, :hasimage)
  end

end
