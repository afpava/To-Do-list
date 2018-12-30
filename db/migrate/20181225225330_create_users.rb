class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :nickname
      t.string :avatar
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.string :gender
      t.date :birth_day
      t.string :country
      t.string :city
      t.string :uid

      t.timestamps
    end
  end
end
