class AddLevelToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :level, :string
  end
end
