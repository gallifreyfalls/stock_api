# frozen_string_literal: true

class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :bearer, null: false, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
