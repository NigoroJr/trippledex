class SummaryController < ApplicationController
  def index
    @people = Person.all
    @payments = Payment.last(10)
  end
end
