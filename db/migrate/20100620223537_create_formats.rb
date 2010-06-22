class CreateFormats < ActiveRecord::Migration
  def self.up
    create_table :formats do |t|
      t.string :name
    end
    remove_column :releases, :format
    add_column :releases, :format_id, :integer
  end

  def self.down
    drop_table :formats
    remove_column :releases, :format_id
    add_column :releases, :format, :integer
  end
end
