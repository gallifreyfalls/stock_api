# frozen_string_literal: true

class ApplicationService
  attr_reader :params, :errors, :result

  def initialize(params = {})
    @params = params
    @errors = {}
  end

  def self.call(params = {})
    new(params).call
  end

  def success?
    errors.blank?
  end

  def call
    process

    self
  end
end
