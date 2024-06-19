class AddPositionToResidents < ActiveRecord::Migration[7.1]
  # This is called a temporary model, it helps avoid weird problems when using
  # a model within a migration. If we change the class ResidentList to
  # PrayerRecipients later, then this ensures that we can still run this
  # migration. Otherwise, the constant ResidentList won't exist and we can't.
  class ResidentList < ActiveRecord::Base
    has_many :residents
  end

  # using an #up and a #down because we don't need to set a position on rollback
  def up
    add_column :residents, :position, :integer
    ResidentList.all.each do |resident_list|
      # use with_index(1) because position is indexed starting at 1 by default.
      resident_list.residents.order(:updated_at).each.with_index(1) do |resident, index|
        puts "Resident #{resident.id}"
        puts "index #{index}"
        resident.update_column :position, index
      end
    end
  end

  def down
    remove_column :residents, :position
  end
end
