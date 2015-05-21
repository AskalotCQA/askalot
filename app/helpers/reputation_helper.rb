module ReputationHelper
  def reputation_icon(user)
    reputation_icon_map = {
        zero:     { class: 'dashed',   icon: '' },
        negative: { class: 'negative', icon: 'fa-minus' },
        bronze:   { class: 'bronze',   icon: 'fa-angle-up' },
        silver:   { class: 'silver',   icon: 'fa-angle-double-up' },
        gold:     { class: 'gold',     icon: 'fa-star-o' },
    }

    return reputation_icon_map[:zero] if user == :anonymous

    reputation = user.profiles.of('reputation').first.value

    return reputation_icon_map[:zero] if reputation == 0
    return reputation_icon_map[:negative] if reputation < 0

    rank = reputation_ranking(reputation)

    return reputation_icon_map[:gold] if rank < Configuration.reputation.gold
    return reputation_icon_map[:silver] if rank < Configuration.reputation.silver

    reputation_icon_map[:bronze]
  end

  private

  def reputation_ranking(reputation)
    User::Profile.of('reputation').where('value > ?', reputation).count / User::Profile.of('reputation').where('value > 0').count.to_f * 100
  end
end
