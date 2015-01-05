class CreateTexts < ActiveRecord::Migration
  
  def change
    create_table :texts do |t|
      t.string :from
      t.string :to
      t.string :body
      t.boolean :complete?, :default => false
      t.integer :user_id
      t.timestamps
    end
  end

end
