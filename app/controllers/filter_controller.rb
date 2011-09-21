class FilterController < ApplicationController
  def new
    @filter = Filter.new
    @categories = Category.all
  end

  def create
  end

  def edit
  end

  def update
  end

end
