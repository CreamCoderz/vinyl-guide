class Admin::GenresController < Admin::AdminController
  def index
    @uncategorized_genre_aliases = EbayItem.group(:genrename).where('genrename is not null').where('genre_id is null').count
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