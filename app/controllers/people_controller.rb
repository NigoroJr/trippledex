class PeopleController < ApplicationController
  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params.require(:person).permit(:name))
    if @person.save
      redirect_to controller: 'summary', action: 'index'
    else
      render 'new'
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    @person.name = params.require(:person).permit(:name)

    if @person.save
      redirect_to controller: 'summary', action: 'index'
    else
      render 'edit'
    end
  end
end
