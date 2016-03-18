module Shared::FavoritesHelper
  def link_to_favorite(favorite, options = {})
    link_to_question favorite.question, options
  end
end
