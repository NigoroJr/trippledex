class DebtsController < ApplicationController
  def edit
    @debt = Debt.find(params[:id])
  end

  def update
    @debt = Debt.find(params[:id])
    @debt.update(debt_params)

    redirect_to controller: 'summary', action: 'index'
  end

  def destroy
    Debt.find(params[:id]).destroy

    redirect_to root_url
  end

  private

  def debt_params
    params.require(:debt).permit(:amount)
  end
end
