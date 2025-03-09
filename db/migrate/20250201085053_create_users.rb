class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username, limit: 20, null: false
      t.string :password_digest, null: false
      t.string :name, limit: 30, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
