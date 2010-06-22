class AddFormatToRelease < ActiveRecord::Migration
  def self.up
    add_column(:releases, :format, :string)
  end

  def self.down
    remove_column(:releases, :format)
  end
end
