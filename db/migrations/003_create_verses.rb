Sequel.migration do
  up do
    create_table(:verses) do
      primary_key :id
      String :scripture, null: false
      String :version, null: false
      String :notation, null: false
    end
  end

  down do
    drop_tables(:verses)
  end
end