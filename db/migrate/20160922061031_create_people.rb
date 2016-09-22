class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :uid
      t.string :name
      t.date :birthday
      t.string :phone
      t.string :city
      t.string :street
      t.string :country
      t.string :avatar
      t.string :email
      t.text :chuck
      t.text :quote

      t.timestamps
    end
  end
end
