# frozen_string_literal: true

class Stock < ApplicationRecord
  acts_as_paranoid

  belongs_to :bearer, required: true

  validates :name, presence: true, uniqueness: true
end
