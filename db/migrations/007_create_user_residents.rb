Sequel.migration do
  up do
    create_table(:user_residents) do
      primary_key :id
      foreign_key :user_id
      String      :name,    null: false
      String      :address, null: false
      String      :status,  null: false
    end
  end

  down do
    drop_tables(:user_residents)
  end
end