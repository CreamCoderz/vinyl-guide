module SeedData
  def self.create_formats
    # Add the default formats
    Format.create(:name => "LP")
    Format.create(:name => "EP")
    Format.create(:name => "Single")
  end

  def self.create_genres
    Genre.create(:name => "Blues")
    Genre.create(:name => "Children's")
    Genre.create(:name => "Classical")
    Genre.create(:name => "Comedy & Spoken Word")
    Genre.create(:name => "Country")
    Genre.create(:name => "Dance & Electronica")
    Genre.create(:name => "Folk")
    Genre.create(:name => "Holiday")
    Genre.create(:name => "Indie/Britpop")
    Genre.create(:name => "Jazz")
    Genre.create(:name => "Latin")
    Genre.create(:name => "Metal")
    Genre.create(:name => "Military")
    Genre.create(:name => "New Age & Easy Listening")
    Genre.create(:name => "Pop")
    Genre.create(:name => "R&B & Soul")
    Genre.create(:name => "Rap & Hip-Hop")
    Genre.create(:name => "Reggae, Ska & Dub")
    Genre.create(:name => "Religious & Devotional")
    Genre.create(:name => "Rock")
    Genre.create(:name => "Rockabilly")
    Genre.create(:name => "Sound Effects & Nature")
    Genre.create(:name => "Soundtracks & Musicals")
    Genre.create(:name => "World Music")
  end

  def self.create_genres_aliases
    GenreAlias.create(:name => "Reggae/Ska", :genre => Genre.find_by_name("Reggae, Ska & Dub"))
    GenreAlias.create(:name => "Religious & Devotional - Swedish", :genre => Genre.find_by_name("Religious & Devotional"))
    GenreAlias.create(:name => "Dance", :genre => Genre.find_by_name("Dance & Electronica"))
    GenreAlias.create(:name => "R&B/Soul", :genre => Genre.find_by_name("R&B & Soul"))
    GenreAlias.create(:name => "Soundtrack, Theater", :genre => Genre.find_by_name("Soundtracks & Musicals"))
    GenreAlias.create(:name => "Pop & Beat: 1960s", :genre => Genre.find_by_name("Pop"))
  end
end