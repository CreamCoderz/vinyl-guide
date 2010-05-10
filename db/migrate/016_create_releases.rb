class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.string :title
      t.string :artist
      t.string :year
      t.string :label
      t.string :matrix_number

      t.timestamps
    end
  end

  def self.down
    drop_table :releases
  end
end
