Komunitný systém otázok a odpovedí slúži aj ako miesto na vzdelávanie. Vo vyriešených otázkach môžeš nájsť množstvo vedomostí, odpovedí na problémy ktoré riešiš. Ako na to?
### Vyhľadávanie
V Askalot-e je implementované vyhľadávanie podľa tagov. Nájdeš ho navrchu zoznamu všetkých otázok. Použiť ho vieš dvoma spôsobmi:

* začneš písať nejaký tag, existujúce tagy sa automaticky dopĺňajú a vyberieš si tie ktoré Ťa zaujímajú
* klikneš na tag, alebo kategóriu pri otázkach a dané tagy sa ti automaticky doplnia do vyhľadávania


<img class="alligned" src="<%= asset_path('screenshots/tag-filter.png') %>" />

### Filtre
V zozname otázok si môžeš otázky filtrovať viacerými možnosťami:

* Aktuálne – všetky otázky, zoradené podľa času poslednej interakcie s otázkou
* Bez odpovede – otázky na ktoré ešte nikto neodpovedal
* Odpovedané – otázky ktoré síce majú odpoveď, ale ešte nebola zvolená najlepšia
* Vyriešené – otázky, kotré už sú uzavreté – bola zvolená najlepšia odpoveď
* Obľúbené – otázky, ktoré boli označené používateľmi ako obľúbené


<img src="<%= asset_path('screenshots/filters.png') %>" />

### Sledovanie používateľov, otázok, tagov, kategórií
V Askalote môžeš sledovať otázky, tagy, kategórie ktoré Ťa zaujímajú. Budú Ti potom chodiť notifikácie o dianí v nich. Aby si niečo sledoval, klikni na <%= icon_tag :eye %>

Ak Ťa zaujíma aktivita niektorého z používateľov, môžeš ho nasledovať. Stačí, ak klikneš na ikonku <%= icon_tag :link %>

### Hlasovanie
Páči sa Ti niektorá otázka, odpoveď, alebo naopak, je niektorá úplne zlá? Zahlasuj za ňu a ovplyvni jej pozíciu v zozname všetkých otázok/odpovedí. Tie horšie budú samozrejme nižšie, tie “hot” budú vyššie v zozname a teda bude ľahšie sa k nim dostať.
### Obľúbené otázky
Otázky si môžeš označiť aj ako obľúbené. Tieto otázky môžeš sledovať (chodia Ti o nich notifikácie). Vidíš tiež počet ľudí, ktorí majú danú otázku ako obľúbenú, je to teda tiež jeden z ukazovateľov toho, čo sa práve rieši.

<img src="<%= asset_path('screenshots/favor.png') %>" />

### Zapojenie učiteľa
Učiteľ v Askalote plní špeciálnu rolu tútora. Aby bolo jasné, ktorý obsah je pridaný učiteľom, sú tieto komentáre a odpovede farebne zvýraznené.
Učiteľ tiež môže ohodnocovať otázky a odpovede. Pri takto ohodnotenej otázke vidíš, či to čo čítaš je dobré alebo zlé.

<img src="<%= asset_path('screenshots/teachers-answer.png') %>" />
