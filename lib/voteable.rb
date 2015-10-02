module Voteable
  extend ActiveSupport::Concern

  included { has_many :votes, as: :voteable }

  def upvotes
    self.votes.where(vote: true).size
  end

  def downvotes
    self.votes.where(vote: false).size
  end

  def net_votes
    upvotes - downvotes
  end
end
