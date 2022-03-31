# frozen_string_literal: true

class Stock::CreateService < ApplicationService
  def process
    set_bearer
    set_stock
    if valid?
      save
      set_result
    else
      set_errors
    end
  end

  private

  attr_reader :stock, :bearer

  def set_stock
    @stock = Stock.new(params)
    @stock.bearer = bearer
  end

  def set_bearer
    return if bearer_params.blank?

    @bearer = Bearer.find_or_initialize_by(bearer_params)
  end

  def bearer_params
    @bearer_params ||= params.delete(:bearer)
  end

  def valid?
    stock.valid? && bearer&.valid?
  end

  def save
    bearer.save unless bearer.persisted?
    stock.save
  end

  def set_result
    @result = stock.as_json(except: :deleted_at, include: { bearer: { only: %i[name id] } })
  end

  def set_errors
    @errors = {
      stock: stock.errors.full_messages,
      bearer: bearer&.errors&.full_messages
    }.compact_blank
  end
end
