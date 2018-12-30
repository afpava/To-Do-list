class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.string :text
      t.integer :priority
      t.boolean :completed
      t.references :user, foreign_key:true

      t.timestamps
    end
  end
end
