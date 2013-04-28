class CreateGenreAliases < ActiveRecord::Migration
  def up
    create_table :genre_aliases do |t|
      t.string :name
      t.integer :genre_id
      t.timestamps
    end
    add_index :genre_aliases, :name

    SeedData.create_genres
    SeedData.create_genres_aliases

    ebay_items_without_genres = EbayItem.where('genrename IS NOT NULL').where(:genre_id => nil)
    p ebay_items_without_genres.count
    ebay_items_without_genres.find_each do |e|
      e.save
      p e.genre.try(:name)
    end
  end

  def down
    drop_table :genre_aliases
  end
end
