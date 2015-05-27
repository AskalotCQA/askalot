Reputáciu získavaš za pýtanie sa otázok a odpovedanie na otázky.

### Výpočet reputácie

Za dané aktivity získaš určité skóre, ktoré sa ti pripočíta k už nadobudnutej reputácii. Výpočet skóre za jednotlivú aktivitu využíva náročnosť otázky a užitočnosť tvojej otázky/odpovede. Čím lepšie a čím náročnejšiu otázku sa ti podarí zodpovedať, tým získaš za danú odpoveď väčšiu reputáciu. Práve preto môže mať používateľ s málo odpoveďami na náročné otázky lepší level reputácie, než používateľ ktorý zodpovie veľa jednoduchých otázok.

### Levely reputácie

Používatelia sú rozdelení do levelov podľa výšky ich reputácie. V každom levely je určitý počet používateľov, preto ak niekto nadobudne väčšiu reputáciu než si mal ty, môže sa ti level znížiť. Ak máš záporný level, je to preto, že ostatní používatelia vyhodnotili väčšinu tvojich otázok/odpovedí negatívne. Celkovo môžeš mať 4 levely reputácie:

- Zlatý level,
- Strieborný level,
- Bronzový level,
- Záporný level.

<div class="user-reputation user-reputation-gold user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'star-o', 'Zlatá reputácia', placement: :bottom %>
</div>

<div class="user-reputation user-reputation-silver user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'angle-double-up', 'Strieborná reputácia', placement: :bottom %>
</div>

<div class="user-reputation user-reputation-bronze user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'angle-up', 'Bronzová reputácia', placement: :bottom %>
</div>

<div class="user-reputation user-reputation-negative user-reputation-lg user-reputation-inline %>">
  <%= tooltip_icon_tag 'minus', 'Záporná reputácia', placement: :bottom %>
</div>

