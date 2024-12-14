class RenameStepCountToMileageInRoutes < ActiveRecord::Migration[7.1]
  def change
    rename_column :routes, :step_count, :mileage
  end
end
