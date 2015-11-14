module University::VotesHelper
  def votes_difference(votable)
    votable.votes_difference >= 0 ? votable.votes_difference : "#{votable.votes_difference}&nbsp;".html_safe
  end
end
