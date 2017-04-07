class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :class_id
      t.string :description
      t.string :short_desc
      t.string :image
      t.string :course_url
      t.string :preview_url
      t.string :duration
      t.integer :provider
      t.boolean :has_cert

      t.timestamps
    end
  end
end
