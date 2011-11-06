class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :parent, :polymorphic => { :default => EbayItem.to_s }
      t.string :title
      t.text :body
      t.references :user
      t.timestamps
    end
    add_index :comments, [:parent_id, :parent_type]
  end

  def self.down
    remove_index :comments, [:parent_id, :parent_type]
    drop_table :comments
  end
end
