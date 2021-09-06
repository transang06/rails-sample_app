class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated_true.latest.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
    @microposts = @user.microposts.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t "user_mailer.check_mail"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.user_deleted"
    else
      flash[:warning] = t "users.user_deleted_fails"
    end
    redirect_to users_path
  end

  def following
    @title = t "relationships.following"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.per_page
    render "show_follow"
  end

  def followers
    @title = t "relationships.followers"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.per_page
    render "show_follow"
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.nil"
    redirect_to root_path
  end
end
