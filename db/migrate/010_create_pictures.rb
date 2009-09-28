class CreatePictures  < ActiveRecord::Migration

  def self.up
    create_table :pictures do |t|
      t.integer :ebay_item_id
      t.string :url
    end
  end

  def self.down
    drop_table :pictures
  end

end