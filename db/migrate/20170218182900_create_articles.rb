class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
    	t.integer :category_id, :null => false
    	t.integer :user_id, :null => false
    	t.string :title, :null => false
    	t.text :post_body
    	t.string :status, :default => "CREATED"
      t.timestamps
    end
  end
end
