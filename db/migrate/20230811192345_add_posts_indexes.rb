class AddPostsIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :posts, :created_at
    add_index :posts, :public
  end
end
