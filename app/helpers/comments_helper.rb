module CommentsHelper
  def get_comments(content_id)
    result = {success: true, errors:[]}
    comments = Comment.where(content_id: content_id, approved: true )
    result[:comments] = comments
    result
  end

  def add_comment(text, content_id)
    result = {success: false, errors:[]}
    if current_user.present?
      comment = Comment.create(user_id: current_user.id, text: text, content_id: content_id)
      if comment.present? && comment.errors.blank?
        result[:success] = true
        result[:comment] = comment
      else
        if comment.errors.present?
          result[:errors].push(comment.errors.messages)
        else
          result[:errors].push("unknown error")
        end
      end
    end
    result
  end
end