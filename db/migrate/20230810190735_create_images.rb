class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :image_path, null: false
      t.string :image_name, null: false
      t.string :description
      t.boolean :public, null: false, default: false
      t.date :taken_on
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
