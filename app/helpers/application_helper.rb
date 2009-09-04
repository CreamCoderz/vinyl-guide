# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_gallery_img(url)
    if url.nil?
      return "http://www.rootsvinylguide.com/noimage.jpg"
    else
      return url
    end
  end

end
