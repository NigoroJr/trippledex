class PaymentsController < ApplicationController
  def index
    @payments = Payment.all
  end

  def new
    @payment = Payment.new
  end

  def show
    @payment = Payment.find(params[:id])

    render @payment
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      Debt.update_from_payment(@payment)

      redirect_to controller: 'summary', action: 'index'
    else
      render 'new'
    end
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])
    @payment.update(payment_params)

    redirect_to controller: 'summary', action: 'index'
  end

  def destroy
    @payment = Payment.find(params[:id])
    @payment.delete

    redirect_to action: 'index'
  end

  private

  def payment_params
    payment = params.require(:payment).permit(:amount, :name, :date)
    payment[:creditor] = Person.find(params[:payment][:creditor].to_i)
    payment[:debtors] = params[:payment][:debtors].map { |id| Person.find(id.to_i) }
    payment
  end
end
