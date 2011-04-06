class CategoriesController < ApplicationController
  before_filter :admin_user, :only => [:destroy, :edit, :index, :new, :grid]

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
  
  def post_data
    message=""
    category_params = { :id => params[:id],:parent_id => params[:parnet_id],:name => params[:name] }
    case params[:oper]
    when 'add'
      if params["id"] == "_empty"
        category = Category.create(category_params)
        message << ('add ok') if category.errors.empty?
      end
      
    when 'edit'
      category = Category.find(params[:id])
      message << ('update ok') if category.update_attributes(category_params)
    when 'del'
      Category.destroy_all(:id => params[:id].split(","))
      message <<  ('del ok')
    when 'sort'
      categorys = Category.all
      categorys.each do |category|
        category.position = params['ids'].index(category.id.to_s) + 1 if params['ids'].index(category.id.to_s) 
        category.save
      end
      message << "sort ak"
    else
      message <<  ('unknown action')
    end
    
    unless (category && category.errors).blank?  
      category.errors.entries.each do |error|
        message << "<strong>#{Category.human_attribute_name(error[0])}</strong> : #{error[1]}<br/>"
      end
      render :json =>[false,message]
    else
      render :json => [true,message] 
    end
  end
  
  
  def grid
    index_columns ||= [:id,:parent_id,:name]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 10

    conditions={:page => current_page, :per_page => rows_per_page}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
    
    @categorys=Category.paginate(conditions)
    total_entries=@categorys.total_entries
    
    respond_with(@categorys) do |format|
      format.json { render :json => @categorys.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
    end
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
