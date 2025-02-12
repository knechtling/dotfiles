return {
  s('text_node', {
    t { 't { "' },
    i(1),
    t { '" },' },
    t { '', '' },
    i(0),
  }),
  s('insert_node', {
    t { 'i(' },
    i(1, '1'),
    t { ', "' },
    i(2, 'Beschreibung'),
    t { '")', '' },
    i(0),
  }),
  s('function_node', {
    t { 'f(function()', '  return ' },
    i(1, '{}'),
    t { '', 'end, {}),', '' },
    i(0),
  }),
}
