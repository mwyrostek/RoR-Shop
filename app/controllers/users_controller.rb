class UsersController < ApplicationController
  before_filter :authenticate, :only => [:profile, :profile_edit, :password, :update, :destroy, :show, :index]
  before_filter :admin_user,   :only => [:destroy, :show, :edit, :index]
  before_filter :super_admin_user, :only => [:toggle]
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
	  sign_in @user
	  flash[:success] = "Welcome to the RoR Shop!"
	  redirect_to profile_path
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def index
    @title = "All users"
    @users = User.all
	store_location
  end
  
  def profile
    @user = current_user
    @title = "Profile"
    store_location
  end
	
  def update
    @user = !params[:id].nil? ? User.find(params[:id]) : current_user
    if @user.update_attributes(params[:user])
	  flash[:success] = "Profile updated."
	  redirect_back_or profile_path
    else
      @title = "Edit profile"
      render 'edit'
    end
  end
  
  def profile_edit
    @user = current_user
    @title = "Edit profile"
	render 'edit'
  end
  
  def edit
    begin 
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound 
      redirect_to root_path
    end
    @title = "Edit profile"
  end
  
  def show
    begin 
      @user = User.find(params[:id]) 
    rescue ActiveRecord::RecordNotFound 
      redirect_to root_path
	end
    @title = "Show user"
	store_location
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end
  
  def toggle
    if (params[:id] == '1')
	  flash[:error] = "You can't do that."
	  redirect_to root_path
	else
      User.find(params[:id]).toggle!(:admin)
      flash[:success] = "Restrictions updated."
      redirect_to users_path
	end
  end
  
  private

  def authenticate
    deny_access unless signed_in?
  end
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
  
  def super_admin_user
    unless current_user.id == 1
	  flash[:error] = "You don't have acces to this function"
      redirect_to users_path
    end
  end
end
