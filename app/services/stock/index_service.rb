# frozen_string_literal: true

class Stock::IndexService < ApplicationService
  def process
    @result = stocks.as_json(except: :deleted_at, include: { bearer: { only: %i[name id] } })
  end

  private

  def stocks
    @stocks ||= ::Stock.includes(:bearer).all
  end
end
