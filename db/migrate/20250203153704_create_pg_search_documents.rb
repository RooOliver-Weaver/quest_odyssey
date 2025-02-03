class CreatePgSearchDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :pg_search_documents do |t|
      t.text :content
      t.references :searchable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
