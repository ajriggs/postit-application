class AddTimestampsToVotes < ActiveRecord::Migration
  def change
    add_timestamps :votes
  end
end
