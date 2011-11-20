class CreateBlogBlogs < ActiveRecord::Migration
  def change
    create_table :blog_contexts do |t|
      t.integer :id
      t.string :context_type
      t.string :full_route
      t.string :terse_route
      t.timestamps
    end

    create_table :blog_blogs do |t|
      t.integer :user_id
      t.integer :context_id
      t.string :title
      t.string :title_for_url
      t.string :teaser
      t.text :content
      t.timestamps
    end
    
    create_table :blog_photos do |t|
      t.integer :id
      t.integer :blog_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end
  end
end

