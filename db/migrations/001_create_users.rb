puts "made it to the migration"

Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :name, null: false
    end
  end

  down do
    drop_tables(:users)
  end
end