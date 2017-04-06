class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :image, default: 'https://cdn1.iconfinder.com/data/icons/mix-color-4/502/Untitled-1-512.png'

      t.timestamps
    end
  end
end
