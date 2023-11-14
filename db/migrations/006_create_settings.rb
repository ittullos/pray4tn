Sequel.migration do
  up do
    create_table(:settings) do
      primary_key :id
      String :s3_bucket_name,    null: false
      String :region,            null: false
      String :access_key_id,     null: false
      String :secret_access_key, null: false
    end
  end

  down do
    drop_tables(:settings)
  end
end
