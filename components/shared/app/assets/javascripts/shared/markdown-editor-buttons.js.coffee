lang = if (window.navigator.userLanguage || window.navigator.language == 'sk') then 'sk' else 'en'

(($) ->
  $.fn.markdown.messages.sk =
    'Bold': "Tučné",
    'Italic': "Kurzíva",
    'Heading': "Nadpis",
    'URL/Link': 'URL/Odkaz'
    'Image': 'Obrázok'
    'Unordered List': 'Zoznam'
    'Ordered List': 'Zoradený zoznam'
    'Code': 'Kus kódu'
    'Quote': 'Citácia'
    'Preview': 'Náhľad'
    'strong text': 'tučný text'
    'emphasized text': 'zdôraznený text'
    'heading text': 'text nadpisu'
    'enter link description here': 'sem vlož opis odkazu'
    'Insert Hyperlink': 'Vložiť Hyperlink'
    'enter image description here': 'sem vlož opis obrázku'
    'Insert Image Hyperlink': 'Vlož adresu obrázku'
    'enter image title here': 'sem vlož opis obrázku'
    'list text here': 'položka zoznamu'
  return
) jQuery


$('.markdown-editor-buttons').markdown
  iconlibrary: 'fa'
  fullscreen: false
  hiddenButtons: 'cmdPreview'
  language: lang
  onSelect: (e) =>
    $(e.$textarea[0]).trigger('propertychange')
