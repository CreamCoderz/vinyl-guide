module CommentsHelper
  def truncate_with_link(comment)
    comment_body = h(truncate(comment.body, :length => 120))
    comment_body += link_to('(more)', comment_path(comment)) if comment.body.length > 120
    comment_body.html_safe
  end
end