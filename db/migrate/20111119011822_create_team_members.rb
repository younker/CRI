class CreateTeamMembers < ActiveRecord::Migration
  def self.up
    create_table :team_members do |t|
      t.integer :id
      t.string :name
      t.string :position
      t.string :email
      t.string :cell_phone
      t.string :office_phone
      t.string :twitter
      t.string :facebook
      t.text :bio
      t.boolean :active
      t.timestamps
    end

    create_table :team_photos do |t|
      t.integer :id
      t.integer :member_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end

  end

  def self.down
    drop_table :team_members
    drop_table :team_photos
  end
end
