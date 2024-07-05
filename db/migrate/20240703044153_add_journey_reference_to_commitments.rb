class AddJourneyReferenceToCommitments < ActiveRecord::Migration[7.1]
  def change
    add_reference :commitments, :journey, null: false, foreign_key: true
  end
end
