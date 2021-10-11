class Api::V1::CommentsController < ApplicationController
  include CommentsHelper

  def comment_params
    params.permit(
      :content_id, :text, :recaptcha_v3_token, :format
    )
  end
  
  def add
    response = add_comment(comment_params[:text], comment_params[:content_id])
    respond_to do |format|
      format.json { render json: response }
    end
  end

  def get
    response = get_comments(comment_params[:content_id])
    respond_to do |format|
      format.json { render json: response }
    end
  end
end