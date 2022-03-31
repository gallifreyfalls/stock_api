# frozen_string_literal: true

class StocksController < ApplicationController
  def index
    service = Stock::IndexService.call
    respond_with_service(service)
  end

  def create
    service = Stock::CreateService.call(stock_params)
    respond_with_service(service)
  end

  def update
    service = Stock::UpdateService.call({ stock: stock, stock_params: stock_params })
    respond_with_service(service)
  end

  def destroy
    stock.destroy!
    head 200
  end

  private

  def stock
    @stock ||= Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, bearer: [:name])
  end

  def respond_with_service(service)
    if service.success?
      render json: service.result
    else
      render json: service.errors.as_json, status: 422
    end
  end
end
