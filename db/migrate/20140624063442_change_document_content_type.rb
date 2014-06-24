class ChangeDocumentContentType < ActiveRecord::Migration
  def change
    change_column :documents, :content, :text
  end
end
