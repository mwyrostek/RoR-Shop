class CategoriesController < ApplicationController
  before_filter :admin_user, :only => [:destroy, :edit, :index, :new]

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show
    @category = Category.find(params[:id])
    @title = @category.name
    store_location
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to categories_path, :notice => 'Category was successfully created.'
    else
      render :action => "new"
    end
  end

  # PUT /categories/1
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to(@category, :notice => 'Category was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /categories/1
  def destroy
    @category = Category.find(params[:id])
    move_items(@category)
    @category.destroy
    flash[:success] = "Category deleted."
    redirect_to(categories_url)
  end
  
  def tree
    @title = "Category Tree"
  end
  
  private
  
   def move_items(from)
    begin 
      to = Category.find_by_name!("Others").id
    rescue ActiveRecord::RecordNotFound
      to = ''
    end
    from.items.each do |item|
      item.category_id = to
      item.save
    end
    unless from.children.empty?
      from.children.each do |child|
        move_items(child)
      end
    end
  end
end
