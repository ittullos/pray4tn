Sequel.migration do
  up do
    create_table(:commitments) do
      primary_key :id
      foreign_key :user_id, :users
      Integer :progress_hours
    end
  end

  down do
    drop_tables(:commitments)
  end
end