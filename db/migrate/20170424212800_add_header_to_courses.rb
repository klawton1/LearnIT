class AddHeaderToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :header, :string
  end
end
