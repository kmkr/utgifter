class ExpenseListController < ApplicationController
  def new
  end

  def create
    content = params[:content]
    logger.debug "CONTENT #{content}"
  end

end
