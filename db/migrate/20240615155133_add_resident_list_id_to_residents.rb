class AddResidentListIdToResidents < ActiveRecord::Migration[7.1]
  def change
    # I would like this to be non-null, but if there are Residents in
    #production, then we need to populate the column first. Usually I'd do this
    # with a Rake task, and then add the non-null constraint in a later release.
    add_reference :residents, :resident_list, index: true
  end
end
