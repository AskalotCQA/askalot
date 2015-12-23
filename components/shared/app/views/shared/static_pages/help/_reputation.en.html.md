You get reputation for your asking and answering.

### Reputation calculation

For asking and answering you get some reputation score, that is added to your previously earned reputation. How much reputation you get for asking a question is determined on question difficulty and question utility. Also the more difficult question you can answer, and the better your answer is received by the rest of community, the more reputation you will earn. Because of that, an user who answered few but difficult questions can have higher reputation than someone who answers many but easier questions.

### Reputation levels

Users are divided into more levels according to their reputation. In each level, there are only predefined number of users in one level, so if someone gets higher reputation, and he achieves highest level, another user is put into lower level. If your reputationis gray, it means that most of yours questions or answers were marked as negative. In Askalot, there are four levels:

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
