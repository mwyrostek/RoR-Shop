class ItemsController < ApplicationController
  # GET /items
  def index
    @items = Item.all
  end

  # GET /items/1
  def show
    @item = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  def create
    @item = Item.new(params[:item])

    if @item.save
      redirect_to(@item, :notice => 'Item was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /items/1
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      redirect_to(@item, :notice => 'Item was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /items/1
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to(items_url)
  end
end
