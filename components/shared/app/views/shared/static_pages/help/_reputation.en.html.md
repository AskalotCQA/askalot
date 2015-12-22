You get reputation for your asking and answering.

### Determine reputation

You get score for activity, which will be added to your actual reputation. Score is combination of difficulty and usefulness of question or answer. Answer for more difficult question means bigger score and reputation. Because of this, the user who has answered few difficult questions can get higher reputation than another who has answered many easier questions.

### Reputation levels

Users are divided to more levels according to reputation. In each level, there are only several users in one level, so if someone gets higher reputation and he achieves highest level, another is put into lower level. If your reputation is gray, it is because most of yours questions or answers were marked as negative. We recognize four levels of reputation:

- Gold level,
- Silver level,
- Bronze level,
- Gray level.

<div class="user-reputation user-reputation-gold user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'star-o', 'Gold level of reputation', placement: :bottom %>
</div>

<div class="user-reputation user-reputation-silver user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'angle-double-up', 'Silver level of reputation', placement: :bottom %>
</div>

<div class="user-reputation user-reputation-bronze user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'angle-up', 'Bronze level of reputation', placement: :bottom %>
</div>

<div class="user-reputation user-reputation-negative user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'minus', 'Gray level of reputation', placement: :bottom %>
</div>
