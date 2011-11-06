module CommentsHelper

  def nested_comment_path(comment_parent)
    "#{polymorphic_path(comment_parent)}#{comments_path}"
  end
end