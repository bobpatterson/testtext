class ChangeTextsCompleteColumnName < ActiveRecord::Migration
  def change
    rename_column :texts, :complete?, :complete
  end
end
