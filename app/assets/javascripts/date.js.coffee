$(document).ready ->
  $.extend($.tablesorter.characterEquivalents,
    'a': 'áä'
    'A': 'ÁÄ'
    'c': 'č'
    'C': 'Ç'
    'd': 'ď'
    'D': 'Ď'
    'e': 'é'
    'E': 'É'
    'i': 'í'
    'I': 'Í'
    'l': 'ľ'
    'L': 'Ľ'
    'n': 'ň'
    'N': 'Ň'
    'o': 'óô'
    'O': 'ÓÔ'
    'r': 'ŕ'
    'R': 'Ŕ'
    's': 'š'
    'S': 'Š'
    't': 'ť'
    'T': 'Ť'
    'u': 'ú'
    'U': 'Ú'
    'y': 'ý'
    'Y': 'Ý'
    'z': 'ž'
    'Z': 'Ž'
  )

  $.extend $.tablesorter.themes.bootstrap,
      table:       ''
      header:      ''
      footerRow:   ''
      footerCells: ''
      icons:       ''
      sortNone:    'fa fa-sort'
      sortAsc:     'fa fa-sort-up'
      sortDesc:    'fa fa-sort-down'
      active:      ''
      hover:       ''
      filterRow:   ''
      even:        ''
      odd:         ''

  $.tablesorter.addWidget
    id: 'numbering'
    format: (table) ->
      $('tr:visible', table.tBodies[0]).each (i) ->
        $(this).find('td').eq(0).text(i + 1)

  $('table[data-sortable="true"]').tablesorter
    theme:         'bootstrap'
    tableClass:    'table'
    cssAsc:        'table-header-asc'
    cssDesc:       'table-header-desc'
    cssChildRow:   'table-children'
    cssHeader:     'table-header'
    cssHeaderRow:  'table-headers'
    cssIcon:       'table-icon'
    cssInfoBlock:  'table-info'
    cssProcessing: 'table-processing'

    headerTemplate: '{content} <span>{icon}</span>'
    # TODO (smolnar) refactor this to something like: widgets: [('numbering' if $(this).attr('data-numbering')), 'uitheme']
    widgets: ['numbering', 'uitheme']

    sortLocaleCompare: true
    textExtraction: (node, table, column) -> $.trim($(node).attr('data-value') or $(node).text())

  $('table').bind 'sortEnd', ->
    fixes()
