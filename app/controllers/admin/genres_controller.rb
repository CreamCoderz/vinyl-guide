class Admin::GenresController < Admin::AdminController
  def index
    genre_names = EbayItem.select('distinct(genrename), genre_id').where('genrename is not null').where('genre_id is null').map(&:genrename).uniq.sort
    @uncategorized_genre_aliases = genre_names.map { |genre_name| GenreAlias.new(:name => genre_name) }
    @genres = Genre.order('name ASC').all(:include => :genre_aliases)
  end

  def create
    genre = Genre.new(params[:genre])
    if genre.save
      flash[:notice] = "The genre #{genre.name} has been saved"
    else
      flash[:notice] = "The genre could not be saved: #{genre.errors.full_messages}"
    end
    redirect_to admin_genres_path
  end
end