class Text < ActiveRecord::Base
  belongs_to :user
  #columns: 
      # t.string :from
      # t.string :to
      # t.string :body
      # t.boolean :complete
      # t.integer :user_id
      # t.timestamps
end
