require 'aws-record'

class CommitmentNoIdError < StandardError; end
class Commitment
  include Aws::Record
  set_table_name ENV["COMMITMENT_TABLE_NAME"]

  integer_attr  :commitment_id, hash_key:  true
  string_attr   :user_id
  string_attr   :journey_id
  string_attr   :commit_date
  string_attr   :target_date

  def self.new_commitment(data)
    time = Time.new
    data["commitment_id"] = next_commit_id
    data["commit_date"]   = "#{time.year}-#{time.strftime("%m")}-#{time.strftime("%d")}"
    data["target_date"]   = "#{time.year + 1}-#{time.strftime("%m")}-#{time.strftime("%d")}"
    commitment = new(data)
    commitment.save!
    commitment
  end

  def self.next_commit_id
    last_commit_id = self.scan.inject(0) { |m, r| r.commitment_id > m ? r.commitment_id : m }
    return last_commit_id + 1
  end

  def self.initial_seed
    commit1 = new(user_id:       "isaac.tullos@gmail.com",
        journey_id:    "I-65 from Franklin to Nashville",
        target_date:   "2023-12-23",
        commit_date:   "2023-03-20",
        commitment_id: 1)
    commit1.save!
    commit2 = new(user_id:       "isaac.tullos@gmail.com",
        journey_id:    "I-40 accross the entire state",
        target_date:   "2023-12-23",
        commit_date:   "2023-03-20",
        commitment_id: 2)
    commit2.save!
  end
end