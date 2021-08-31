class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :micropost_image, only: :create

  def create
    if @micropost.save
      flash[:success] = t "microposts.created"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate page: params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.deleted"
      redirect_to request.referer || root_path
    else
      flash[:danger] = t "microposts.err"
      redirect_to root_path
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def micropost_image
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost.present?

    flash[:danger] = t "microposts.nil"
    redirect_to root_url 
  end
end
