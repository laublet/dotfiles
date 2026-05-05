-- https://neovim.io/doc/user/spell.html
-- LaTeX: multi-language spell dictionaries (Neovim spell, not LTeX).
-- Download missing .spl with: :spelllang fr,en,es  (then :spelllang en fr es if prompted)
-- LTeX grammar: one language per buffer — use :GrammarLang <code> then :GrammarCheck
vim.opt_local.spell = true
vim.opt_local.spelllang = "fr,en,es"
