module University::ReputationHelper
  def reputation_icon(user)
    reputation_icon_map = {
        zero:     { class: 'none' },
        negative: { class: 'negative', title: t('user.reputation.negative'), icon: 'minus' },
        bronze:   { class: 'bronze',   title: t('user.reputation.bronze'),   icon: 'angle-up' },
        silver:   { class: 'silver',   title: t('user.reputation.silver'),   icon: 'angle-double-up' },
        gold:     { class: 'gold',     title: t('user.reputation.gold'),     icon: 'star-o' },
    }

    return reputation_icon_map[:zero] if user == :anonymous

    reputation = user.profiles.of('reputation').first.value

    return reputation_icon_map[:zero] if reputation == 0
    return reputation_icon_map[:negative] if reputation < 0

    rank = reputation_ranking(reputation)

    return reputation_icon_map[:gold] if rank < University::Configuration.reputation.gold
    return reputation_icon_map[:silver] if rank < University::Configuration.reputation.silver

    reputation_icon_map[:bronze]
  end

  private

  def reputation_ranking(reputation)
    University::User::Profile.of('reputation').where('value > ?', reputation).count / University::User::Profile.of('reputation').where('value > 0').count.to_f * 100
  end
end
