class Admin::GenreAliasesController < Admin::AdminController
  def create
    genre_alias = GenreAlias.new(params[:genre_alias])
    if genre_alias.save
      flash[:notice] = "The genre alias #{genre_alias.name} has been saved for genre #{genre_alias.genre.name}"
    else
      flash[:notice] = "The genre alias could not be saved: #{genre_alias.errors.full_messages}"
    end
    redirect_to admin_genres_path
  end
end