Sequel.migration do
  up do
    create_table(:routes) do
      primary_key :id
      Integer  :started_at,   null: false
      Integer  :stopped_at
      Integer  :mileage,      null: false
      Integer :prayer_count, null: false
      Integer :seconds     , null: false
    end
  end

  down do
    drop_tables(:routes)
  end
end