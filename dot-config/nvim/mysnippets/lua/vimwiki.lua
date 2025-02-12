local getPath = function()
  local current_file_path = vim.fn.expand '%:p'

  local parent_path = vim.fn.fnamemodify(current_file_path, ':h:h')

  return parent_path
end

local makePath = function()
  local current_file_path = vim.fn.expand '%:p'

  local current_working_directory = vim.fn.getcwd()

  local relative_path = vim.fn.fnamemodify(current_file_path, ':p:h')
  relative_path = vim.fn.substitute(relative_path, '^' .. vim.fn.escape(current_working_directory, '/\\') .. '/', '', '')

  return relative_path
end

local addDirect = function()
  local current_file_path = vim.fn.expand '%:p'

  local base_path_prefix = '/Users/<SET YOUR BASE PATH!!!>'

  if vim.fn.stridx(current_file_path, base_path_prefix) == 0 then
    local relative_path_without_base = vim.fn.substitute(current_file_path, '^' .. base_path_prefix, '', '')

    local directory_only = vim.fn.fnamemodify(relative_path_without_base, ':h')

    return '/' .. directory_only
  end

  return 'ERROR'
end

return {
  s('div', {
    t { '----', '', '' },
    i(1, 'Write'),
    t { '', '', '----' },
  }),

  s('home', {
    t '[[/index|Home]]',
  }),

  s('to_back)', {
    t '[[',
    t '//',
    f(getPath),
    t '/',
    i(1, 'back directory'),
    t '|Back]]',
  }),

  s('create_new_dir', {
    t '[[',
    f(addDirect),
    t '/',
    i(1, 'file'),
    t '/',
    rep(1),
    t '|',
    i(2, 'name'),
    t ']]',
  }),

  s('h1', {
    t '= ',
    i(1, 'Name header'),
    t ' =',
  }),

  s('h3', {
    t '=== ',
    i(1, 'Name header'),
    t ' ===',
  }),
  s('h5', {
    t '===== ',
    i(1, 'Name header'),
    t ' =====',
  }),

  s('bold', {
    t '*',
    i(1, 'Text'),
    t '*',
  }),

  s('italic', {
    t '_',
    i(1, 'Text'),
    t '_',
  }),

  s('superscript', {
    i(1, 'Big'),
    t '^',
    i(2, 'Small'),
    t '^',
  }),

  s('subscript', {
    i(1, 'big'),
    t ',,',
    i(2, 'small'),
    t ',,',
  }),

  s('create_file', {
    t '[[',
    i(1, 'Location'),
    t '|',
    i(2, 'Linktitle'),
    t ']]',
  }),

  s('image_large_down', {
    t '{{local:',
    i(1, 'file'),
    t '|',
    i(2, 'large picture'),
    t '|style="max-width:500px;height:auto;"}}',
  }),

  s('image_medium_down', {
    t '{{local:',
    i(1, 'file'),
    t '|',
    i(2, 'medium picture'),
    t '|style="max-width:300px;height:auto;"}}',
  }),

  s('image_small_down', {
    t '{{local:',
    i(1, 'file'),
    t '|',
    i(2, 'small picture'),
    t '|style="max-width:100px;height:auto;"}}',
  }),

  s('todo_incomp', {
    t '- [ ] ',
    i(1, 'reminder'),
  }),

  s('todo_done', {
    t '- [X] ',
    i(1, 'reminder'),
  }),

  s('todo_notyet', {
    t '- [.] ',
    i(1, 'reminder'),
  }),

  s('comingsoon', {
    t { '[[/index|Home]]', '', '' },
    t 'Coming Soon...',
  }),
  s('inline math', {
    t '$ ',
    i(1),
    t ' $',
    i(0),
  }),

  s('block math', {
    t { '{{$', '' },
    i(0),
    t { '', '}}$' },
  }),

  s('frac', {
    t '\\frac{',
    i(1, 'numerator'),
    t '}{',
    i(2, 'denominator'),
    t '}',
  }),

  -- Power
  s('pow', {
    i(1, 'base'),
    t '^',
    t '{',
    i(2, 'exponent'),
    t '}',
  }),

  -- Square Root
  s('sqrt', {
    t '\\sqrt{',
    i(1, 'expression'),
    t '}',
  }),

  -- nth Root
  s('nroot', {
    t '\\sqrt[',
    i(1, 'n'),
    t ']{',
    i(2, 'expression'),
    t '}',
  }),

  -- Sum
  s('sum', {
    t '\\sum_{',
    i(1, 'i=1'),
    t '}^{',
    i(2, 'n'),
    t '} ',
    i(3, 'expression'),
  }),

  -- Integral
  s('int', {
    t '\\int_{',
    i(1, 'a'),
    t '}^{',
    i(2, 'b'),
    t '} ',
    i(3, 'expression'),
    t ' \\, d',
    i(4, 'x'),
  }),

  -- Limit
  s('lim', {
    t '\\lim_{',
    i(1, 'x \\to \\infty'),
    t '} ',
    i(2, 'expression'),
  }),

  -- Matrix
  s('matrix', {
    t '\\begin{matrix}',
    t { '', '' },
    i(1, 'a & b \\\\ c & d'),
    t { '', '\\end{matrix}' },
  }),

  -- Cases
  s('cases', {
    t '\\begin{cases}',
    t { '', '' },
    i(1, 'expression_1 & \\text{if condition_1} \\\\ expression_2 & \\text{if condition_2}'),
    t { '', '\\end{cases}' },
  }),

  -- Partial Derivative
  s('partial', {
    t '\\frac{\\partial ',
    i(1, 'f'),
    t '}{\\partial ',
    i(2, 'x'),
    t '}',
  }),

  -- Derivative
  s('deriv', {
    t '\\frac{d',
    i(1, 'y'),
    t '}{d',
    i(2, 'x'),
    t '}',
  }),

  -- Summation with Limits
  s('prod', {
    t '\\prod_{',
    i(1, 'i=1'),
    t '}^{',
    i(2, 'n'),
    t '} ',
    i(3, 'expression'),
  }),
  s('bbR', {
    t '\\mathbb{R}',
  }),

  -- Set of Integers (ℤ)
  s('bbZ', {
    t '\\mathbb{Z}',
  }),

  -- Set of Natural Numbers (ℕ)
  s('bbN', {
    t '\\mathbb{N}',
  }),

  -- Set of Complex Numbers (ℂ)
  s('bbC', {
    t '\\mathbb{C}',
  }),

  -- Set of Rational Numbers (ℚ)
  s('bbQ', {
    t '\\mathbb{Q}',
  }),

  -- Vector Notation
  s('vec', {
    t '\\vec{',
    i(1, 'v'),
    t '}',
  }),

  -- Bold Symbol
  s('bf', {
    t '\\mathbf{',
    i(1, 'v'),
    t '}',
  }),

  -- Transpose
  s('trans', {
    i(1, 'A'),
    t '^\\top',
  }),

  -- Dot Product
  s('dot', {
    i(1, 'a'),
    t ' \\cdot ',
    i(2, 'b'),
  }),

  -- Cross Product
  s('cross', {
    i(1, 'a'),
    t ' \\times ',
    i(2, 'b'),
  }),

  -- Norm (||v||)
  s('norm', {
    t '\\|',
    i(1, 'v'),
    t '\\|',
  }),

  -- Floor Function
  s('floor', {
    t '\\lfloor ',
    i(1, 'x'),
    t ' \\rfloor',
  }),

  -- Ceiling Function
  s('ceil', {
    t '\\lceil ',
    i(1, 'x'),
    t ' \\rceil',
  }),

  -- Logical And (∧)
  s('land', {
    t '\\land',
  }),

  -- Logical Or (∨)
  s('lor', {
    t '\\lor',
  }),

  -- Logical Not (¬)
  s('lnot', {
    t '\\neg',
  }),

  -- Implication (→)
  s('implies', {
    t '\\rightarrow',
  }),

  -- If and Only If (↔)
  s('iff', {
    t '\\leftrightarrow',
  }),
}
