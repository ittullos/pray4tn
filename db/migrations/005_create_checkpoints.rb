Sequel.migration do
  up do
    create_table(:checkpoints) do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :route_id, :routes
      Integer :timestamp, null: false
      String :lat, null: false
      String :long, null: false
      String :type
    end
  end

  down do
    drop_tables(:checkpoints)
  end
end