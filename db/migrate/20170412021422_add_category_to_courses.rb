class AddCategoryToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :category, :string
    add_column :courses, :views, :integer, default: 0
  end
end
