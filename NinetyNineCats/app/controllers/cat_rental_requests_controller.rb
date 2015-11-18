class CatRentalRequestsController < ApplicationController
  def index
    @cat = Cat.find_by(id: params[:cat_id])
    @rentals = @cat.cat_rental_requests
  end

  def new
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new
  end

  def create
    @cats = Cat.all
    @cat_rental_request = CatRentalRequest.new(rental_params)

    @cat_rental_request.status = "APPROVED"
    if @cat_rental_request.save
      redirect_to cat_url(Cat.find_by(id: @cat_rental_request.cat_id)) + '/cat_rental_requests'
    else
      render :new
    end
  end

  def update
    if params[:stuff] == "approve!"
      @cat_rental_request = CatRentalRequest.find_by(id: params[:id])
      @cat_rental_request.approve!
      redirect_to cat_url(@cat_rental_request.cat)
    else
      @cat_rental_request = CatRentalRequest.find_by(id: params[:id])
      @cat_rental_request.deny!
      redirect_to cat_url(@cat_rental_request.cat)
    end
  end


  def rental_params
    params[:cat_rental_request].permit(:cat_id, :start_date, :end_date)
  end
end
