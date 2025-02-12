local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node

-- Helper functions to get date and time
local function get_current_date()
  return os.date '%d.%m.%Y'
end

local function get_current_time()
  return os.date '%H:%M'
end

local function get_next_monday()
  local today = os.time()
  local day_of_week = tonumber(os.date('%w', today))
  local days_until_monday = (1 - day_of_week + 7) % 7
  return os.date('%d.%m.%Y', today + days_until_monday * 24 * 60 * 60)
end

-- Snippet for the protocol

-- Return snippets to be loaded by luasnip
return {
  s('protocol', {
    t { '= Protokoll Gruppe 01' },
    t { '', '', 'Treffen am ' },
    f(function()
      return os.date '%d.%m.%Y'
    end, {}),
    t { '', '', 'Ort:      ' },
    i(1, 'APB'),
    t { '', 'Beginn:   ' },
    f(function()
      return os.date '%H:%M'
    end, {}),
    t { ' Uhr +' },
    t { '', 'Ende:     xx:xx Uhr' },
    t { '', '', '__Schriftführer__: Anton' },
    t { '', '', '*Nächstes Treffen:* +' },
    t { 'XX.XX.20XX, xx:xx Uhr, Ort des nächsten Treffens' },
    t { '', '', '__Teilnehmer:__' },
    t { '', '- Yongbo', '- Anton', '- Jannik', '- Abdülkadir', '- Alexander Lothar', '- Maria', '- Duy Quan', '- Anak Agung Ngurah' },
    t { '', '', '== Bemerkungen', '', '== Retrospektive des letzten Sprints' },
    t { '', '*Issue referenziert die Issue ID von GitHub*', '', '[option="headers"]', '' },
    t { '|===', '|Issue |Aufgabe |Status |Bemerkung', '|…     |…       |…      |…', '|===', '', '' },
    t { '== Aktueller Stand', '', '== Planung des nächsten Sprints', '*Issue referenziert die Issue ID von GitHub*' },
    t { '', '', '[option="headers"]', '|===', '|Issue |Titel |Beschreibung |Verantwortlicher |Status' },
    t { '', '|…     |…     |…            |…                |…', '|===' },
  }),
}
