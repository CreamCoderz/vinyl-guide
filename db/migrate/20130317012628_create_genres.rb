class CreateGenres < ActiveRecord::Migration
  def up
    create_table :genres do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    SeedData.create_genres

    execute(%|alter table ebay_items drop index index_ebay_items_on_size,
                                     drop index index_ebay_items_on_title,
                                     drop index index_ebay_items_on_format_id,
                                     add column genrename VARCHAR(255),
                                     add column genre_id int(11),
                                     add index index_ebay_items_on_genre_id_and_format_id(genre_id, format_id)|
    )


    id = execute("select id from genres where name='Reggae, Ska & Dub' limit 1")
    execute("update ebay_items set genre_id=#{id.first.first}")
  end

  def down
    execute(%|alter table ebay_items add index index_ebay_items_on_size(size),
                                         add index index_ebay_items_on_title(title),
                                         add index index_ebay_items_on_format_id(format_id),
                                         drop index index_ebay_items_on_genre_id_and_format_id,
                                         drop column genrename,
                                         drop column genre_id|)
    drop_table :genres
  end
end
