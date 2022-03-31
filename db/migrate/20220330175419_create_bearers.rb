# frozen_string_literal: true

class CreateBearers < ActiveRecord::Migration[6.1]
  def change
    create_table :bearers do |t|
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
