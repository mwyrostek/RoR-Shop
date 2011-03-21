class UsersController < ApplicationController
  before_filter :authenticate, :only => [:profile, :profile_edit, :update]
  before_filter :admin_user,   :only => [:destroy, :edit, :index, :new, :show]
  before_filter :super_admin_user, :only => [:toggle]
  
  def signup
    redirect_to root_path, :alert => "You can't sign up twice" unless !signed_in?
    @user = User.new
    @title = "Sign up"
  end
  
  def new
    @user = User.new
    @title = "New user"
  end

  def create
    @user = User.new(params[:user])  
    if @user.save
        flash[:success] = "Account created."
        redirect_back_or root_path
    elsif current_user.admin?
      @title = "New user"
      render 'new'
    else
      @title = "Sign up"
      render 'signup'
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
    if (params[:id] == '1')
      flash[:error] = "You can't do that."
      redirect_to root_path
    else
      begin 
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound 
        redirect_to root_path
      end
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
    if (params[:id] == '1')
      flash[:error] = "You can't do that."
    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
	end
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
end