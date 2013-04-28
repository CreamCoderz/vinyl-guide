class Genre < ActiveRecord::Base

  #BLUES = Genre.find_by_name("Blues")
  #CHILDRENS = Genre.find_by_name("Children's")
  #CLASSICAL = Genre.find_by_name("Classical")
  #COMEDY_AND_SPOKEN_WORD = Genre.find_by_name("Comedy & Spoken Word")
  #COUNTRY = Genre.find_by_name("Country")
  #DANCE_AND_ELECTRONICA = Genre.find_by_name("Dance & Electronica")
  #FOLK = Genre.find_by_name("Folk")
  #HOLIDAY = Genre.find_by_name("Holiday")
  #JAZZ = Genre.find_by_name("Jazz")
  #LATIN = Genre.find_by_name("Latin")
  #METAL = Genre.find_by_name("Metal")
  #MILITARY = Genre.find_by_name("Military")
  #NEW_AGE_AND_EASY_LISTENING = Genre.find_by_name("New Age & Easy Listening")
  #POP = Genre.find_by_name("Pop")
  #R_AND_B_AND_SOUL = Genre.find_by_name("R&B & Soul")
  #RAP_AND_HIP_HOP = Genre.find_by_name("Rap & Hip-Hop")
  REGGAE_SKA_AND_DUB = Genre.find_by_name("Reggae, Ska & Dub")
  #RELIGIOUS_AND_DEVOTIONAL = Genre.find_by_name("Religious & Devotional")
  #ROCK = Genre.find_by_name("Rock")
  #SOUND_EFFECTS_AND_NATURE = Genre.find_by_name("Sound Effects & Nature")
  #SOUNTRACKS_AND_MUSICALS = Genre.find_by_name("Soundtracks & Musicals")
  #WORLD_MUSIC = Genre.find_by_name("World Music")

  validates_uniqueness_of :name

  def self.find_by_ebay_genre(ebay_genre)
    find_by_name(ebay_genre) || GenreAlias.find_by_name(ebay_genre).try(:genre)
  end
end
