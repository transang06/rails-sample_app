class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      format_html_js
    else
      flash[:danger] = t "users.nil"
      redirect_to root_path
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user
      current_user.unfollow @user
      format_html_js
    else
      flash[:danger] = t "users.nil"
      redirect_to root_path
    end
  end

  private

  def format_html_js
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
