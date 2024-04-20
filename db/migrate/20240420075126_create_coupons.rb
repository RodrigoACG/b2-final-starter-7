class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.string :dollar_off
      t.integer :status, default: 0 
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
