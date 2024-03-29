class ReviewsController < ApplicationController
  before_action :only => [:edit, :destroy] do
    if !current_user.admin
      flash[:alert] = "You are not authorized for this action."
    end
    redirect_to products_path unless current_user && current_user.admin
  end
  def new
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new
    render :new
  end

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new(review_params)
    if @review.save
      flash[:notice] = "Review successfully added!"
      redirect_to product_path(@product)
    else
      flash[:alert] = "There was an error in creating your review!"
      render :new
    end
  end

  def show
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    render :show
  end

  def edit
    @product = Product.find(params[:product_id])
    @review = Review.find(params[:id])
    render :edit
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      flash[:notice] = "Review successfully updated!"
      redirect_to product_path(@review.product)
    else
      flash[:alert] = "There was an error in updating your review!"
      @product = Product.find(params[:product_id])
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.destroy
      flash[:notice] = "Review successfully deleted!"
      redirect_to product_path(@review.product)
    end
  end

  private
    def review_params
      params.require(:review).permit(:author, :content_body, :rating)
    end
end
