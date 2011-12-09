class TransactionsController < ApplicationController
  respond_to :json

  def index
    @transactions = current_user.transactions

    respond_with @transactions
  end

  def update
    transaction = current_user.transactions.where(:id => params[:id]).first

    if transaction
      transaction.update_attributes(params[:transaction])
      head :ok
    else
      head :forbidden
    end

  end

  def create
    transaction = Transaction.new(params[:transaction])
    transaction.user = current_user

    if transaction.save
      respond_with transaction
    else
      flash[:error] = "Fikk ikke opprettet transaksjon"
      redirect_to :create
    end
  end

  def destroy
    transaction = current_user.transactions.where(:id => params[:id]).first

    if transaction
      transaction.destroy
      head :ok
    else
      head :forbidden
    end

  end

end
