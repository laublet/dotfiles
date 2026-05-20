# WezTerm — terminal émulateur (local)

> GPU-accelerated terminal, Lua config, native multiplexer (panes / tabs / workspaces).
> Config : [`conf/wezterm/.wezterm.lua`](../conf/wezterm/.wezterm.lua) (commenté en haut, source de vérité).
> Hub des raccourcis multi-app : [keyboard-navigation.md](keyboard-navigation.md#wezterm).

## Panes (smart-splits, intégration Neovim)

| Raccourci | Action |
|-----------|--------|
| `Cmd + D` | Split horizontal (pane à droite) |
| `Cmd + Shift + D` | Split vertical (pane en bas) |
| `Cmd + W` | Close pane (confirmation) |
| `Ctrl + arrows` | Navigate pane (traverse vers Neovim sans saut de focus) |
| `Ctrl + Shift + arrows` | Idem — fallback macOS quand `Ctrl+←/→` est volé par Mission Control |
| `Ctrl + Alt + arrows` | Resize pane (±3 cells) |
| `Ctrl + Alt + Shift + arrows` | Swap avec le voisin dans la direction (2 panes = rotate, 3+ = picker) |
| `Cmd + Shift + Z` | Toggle zoom pane (Cmd+Z reste libre pour undo) |
| `Cmd + Shift + X` | Rotate panes (2 = swap positions, 3+ = cycle) |

## Tabs

| Raccourci | Action |
|-----------|--------|
| `Cmd + T` | Nouveau tab |
| `Cmd + 1`..`9` | Aller au tab N |
| `Cmd + Shift + ←/→` | Tab précédent / suivant |
| `Cmd + Shift + Ctrl + ←/→` | **Déplacer** le tab actif à gauche / droite (intercaler entre deux tabs) |
| `Cmd + Shift + ,` | Renommer le tab courant (input vide = reset, persisté via resurrect) |

Le titre du tab affiche `<index>: <titre>`. Si un agent CLI (cursor-agent, claude, aider, codex) tourne dans le pane actif, son glyph de status (`⏳`, `✅`, `🧭`, `🔐`, `🔄`, spinner braille) est préfixé automatiquement et disparaît dès que l'agent quitte.

## Copy mode & scrollback search

| Raccourci | Action |
|-----------|--------|
| `Cmd + Alt + Space` | Entrer en copy mode (vim-like) |
| `Cmd + F` | Scrollback search overlay (séparé du copy mode) |
| (copy mode) `/` ou `?` | Démarrer un pattern de recherche |
| (copy mode) `Enter` | AcceptPattern → auto-select du match courant |
| (copy mode) `n` / `Shift+n` | Match suivant / précédent (vim-style) |
| (copy mode) `Ctrl+n` / `Ctrl+p` | Idem (alternative) |
| (copy mode) `y` | Copier la sélection |
| (copy mode) `Esc` | Si sélection → clear ; sinon ClearPattern + close |
| (copy mode) `s` | QuickSelect (jump-to-word style easymotion) |
| `Cmd + Shift + F` | QuickSelect top-level (URLs, paths, hashes, mots 3+) |

**Pourquoi Esc clear le pattern** : WezTerm relance la recherche à chaque redraw du terminal, donc un pattern laissé en place ramène périodiquement le curseur sur le premier match ([wezterm#5952](https://github.com/wez/wezterm/issues/5952)).

## Scrollback — navigation sémantique (OSC 133)

Le shell zsh émet des markers OSC 133 (`\e]133;A` avant chaque prompt, `\e]133;C` au début de l'output). WezTerm sait du coup où sont les prompts et délimite chaque "command + output" comme une **semantic zone** identifiable.

| Raccourci | Action |
|-----------|--------|
| `Cmd + ↑` | Scroll au prompt précédent dans le scrollback |
| `Cmd + ↓` | Scroll au prompt suivant |
| `Cmd + Shift + ↑` | **Fast path** : copie directe du dernier output au clipboard. Flash violet de la status bar pour confirmer. |
| `Ctrl + Shift + O` | **Picker** fzf sur **tous** les outputs du pane. Preview à droite (bat), Enter copie, Esc annule. (Mnémonique : **O**utput.) |

Le picker se comporte comme un widget fzf classique (Ctrl+T, Ctrl+R) : fzf hérite de `FZF_DEFAULT_OPTS='-m --height 40% --border'` et **flotte inline** dans la pane courante (40% en bas, scrollback visible au-dessus). À la sortie (Enter / Esc / Ctrl+C), le prompt zsh est redessiné, zéro impact sur la layout.

Mécanique : WezTerm dump les outputs dans un tmpdir, écrit le chemin dans `/tmp/.wezterm-output-picker.<pane_id>`, puis envoie `Ctrl+X Ctrl+P` au tty. Un widget ZLE (`__wezterm_output_picker_widget` dans [`conf/zsh/zshrc`](../conf/zsh/zshrc)) lit le marker et lance le picker dans le shell courant.

Fallback : si la pane n'est pas un zsh interactif (vim, TUI, autre process en cours), WezTerm bascule sur l'ancien comportement `SplitPane Down 75%` (le widget ZLE ne peut pas s'exécuter si zsh n'est pas au foreground).

Labels du picker = la ligne de commande qui a produit chaque output (extraite de la ligne juste au-dessus du début de la zone), fallback sur la 1ʳᵉ ligne de l'output si le prompt n'a pas pu être récupéré. Outputs numérotés `001` (dernier) → `NNN` (plus ancien).

Setup côté shell : `_osc133_precmd` / `_osc133_preexec` dans [`conf/zsh/zshrc`](../conf/zsh/zshrc) émettent les markers OSC 133 que WezTerm utilise pour découper les semantic zones (compatible starship/p10k — les markers entourent le prompt sans le toucher).

Script picker : [`bin/wezterm-output-picker`](../bin/wezterm-output-picker) (bash + fzf + bat + pbcopy, self-cleanup via `trap EXIT`).

Usage typique : tu lances `cargo test`, ça échoue, tu copies direct avec `Cmd+Shift+↑`. Si entre-temps tu as enchainé deux trois autres commandes et que l'erreur intéressante est plus loin, `Ctrl+Shift+O` ouvre le picker, tu reconnais `cargo test` dans la liste, preview montre la stack d'erreur complète, Enter → clipboard. Rien n'a touché le clipboard history sauf le `pbcopy` final.

### Sécurité du picker

- Les outputs sont dumpés via `mktemp -d` qui crée le dossier dans `$TMPDIR` (sur macOS = `/var/folders/<hash>/T/`, **per-user**), avec perms **0700** atomiquement (race-free, nom imprévisible).
- Cleanup : `trap 'rm -rf "$tmpdir"' EXIT` → effacement immédiat sur Enter / Esc / Ctrl+C / SIGHUP (fermeture du pane).
- Si le picker se fait `SIGKILL` (rare), les fichiers persistent dans ton `$TMPDIR` privé jusqu'au prochain reboot ou cleanup macOS (~3 jours d'inactivité). Aucune fuite vers `/tmp` partagé.
- À retenir : les outputs sont déjà en mémoire dans le scrollback WezTerm. Le dump disque est une copie temporaire avec les mêmes garanties que ton `$HOME`.

**Pas de copie de la commande tapée** : ça demanderait de wrapper `PROMPT` avec les markers OSC 133 `;P` / `;B`, ce qui rentre en conflit avec starship qui reconstruit `PROMPT` à chaque cycle precmd. Pour récupérer une commande passée : `!!` (dernière), `!-N` (N-ième en arrière), ou `Ctrl+R` (fzf history via Atuin).

**Pas de notif macOS** : `window:toast_notification` utilise NSUserNotificationCenter, déprécié depuis macOS 11 et silencieusement bloqué sur les versions récentes même avec les notifs WezTerm autorisées. Les feedbacks visuels passent par flash de status bar (in-app) ou directement dans le picker fzf.

## Pickers (fuzzy finders WezTerm-natifs)

| Raccourci | Action |
|-----------|--------|
| `Cmd + Shift + P` | Command palette WezTerm (toutes les actions / key bindings, défaut) |
| `Cmd + Ctrl + Space` | **CharSelect** — ouvre direct sur le groupe **NerdFonts** (fuzzy filter live). `Tab` cycle vers Emoji / UnicodeNames / etc. Copie au clipboard (et Primary). |
| `Cmd + Shift + ;` | **Launch menu** — pré-rempli avec `btop`, `gitui`, `glab-pick`, `lazydocker`, `nettop`, `mac-startup-clean`. Le sélectionné se lance dans le pane courant. |
| `Cmd + Shift + L` | Workspace switcher (voir section Workspaces) |

Pour ajouter une entrée au launch menu : éditer `config.launch_menu` dans `.wezterm.lua` (`{ label = "...", args = { ... } }`).

## Hyperliens cliquables — `file:line:col`

Toute mention d'un path style compiler output (`src/foo.ts:42:10`, `./tests/bar.rs:128`, `~/dotfiles/conf/zsh/zshrc:74`) devient cliquable. **Cmd + clic** → ouvre le fichier dans **Neovim** à la bonne ligne (`nvim +line path`, cwd = pane courante).

Couvre tsc, eslint, biome, cargo, vitest, jest, rspec, pytest, etc.

## Bell & notifications

| Raccourci / déclencheur | Comportement |
|-------------------------|--------------|
| `printf '\a'` ou tout TUI émettant `BEL` | Beep audio désactivé. Flash discret de la **couleur du curseur** (75 ms in / 150 ms out). Notification macOS "WezTerm — Bell — `<pane title>`". |

Pattern utile : `make build && printf '\a'` ou `long-running-command; printf '\a'` → notif Mac quand c'est fini, même si la fenêtre est en arrière-plan.

## Workspaces

| Raccourci | Action |
|-----------|--------|
| `Cmd + Shift + L` | Switch workspace (fuzzy launcher, liste les existants) |
| `Cmd + Shift + N` | Nouveau / switch workspace par nom (prompt) |

Chaque fenêtre a son propre workspace actif. Le nom du workspace courant est affiché dans la status bar à gauche.

## Resurrect — persistence de session

Plugin [MLFlexer/resurrect.wezterm](https://github.com/MLFlexer/resurrect.wezterm). Auto-save **workspace uniquement** toutes les 5 min (les `window/*.json` / `tab/*.json` ont été désactivés car les titres Cursor Agent changent à chaque tick de spinner et polluaient massivement le dossier).

| Raccourci | Action |
|-----------|--------|
| `Cmd + Shift + S` | Save manuel du workspace courant (overwrite par nom — pas d'accumulation) |
| `Cmd + Shift + O` | Restore : fuzzy finder sur tous les états sauvegardés |
| `Cmd + Shift + Ctrl + D` | Delete un état sauvegardé (fuzzy) |
| `Cmd + Shift + Ctrl + X` | Wipe **tous** les états (tape `DELETE` pour confirmer) |

Au démarrage, WezTerm restaure automatiquement le dernier workspace actif. Fallback : nouvelle fenêtre maximisée.

État sur disque : `~/Library/Application Support/wezterm/plugins/.../resurrect.wezterm/state/` (sous-dossiers `workspace/`, `window/`, `tab/`).

## Reload config

| Raccourci | Action |
|-----------|--------|
| `Ctrl + Shift + R` ou `Cmd + R` | Reload `.wezterm.lua` (défaut WezTerm) |

WezTerm reload aussi automatiquement à chaque sauvegarde du fichier.

## Status bar

À gauche uniquement : nom du workspace actif + nom de la key table active (copy mode, leader pending, …). Pas de clock / CPU / RAM à droite — l'horloge vit dans la menu bar macOS, les métriques système se consultent à la demande via `btop` / `bandwhich` / `nettop`.

## Petits trucs

- `Cmd + Backspace` → envoie `Ctrl+U` (kill line backward en zsh / vim insert). Réflexe macOS qui passerait sinon dans le vide.
- `Ctrl+Tab` / `Ctrl+Shift+Tab` → remappés en `Ctrl+PageDown` / `Ctrl+PageUp` pour rester distinct dans les TUIs (Neovim buffer nav).
- `Ctrl+L` et `Ctrl+H` restent libres pour le shell (`clear` et `backspace`) — pas de Ctrl+hjkl pour panes, on utilise les arrows.
- **Kitty keyboard protocol** activé (`enable_kitty_keyboard = true`) : reporting clavier moderne, distingue `Ctrl+I` de `Tab`, préserve les bits Shift/Ctrl/Alt/Cmd des home-row mods Kyria jusque dans Neovim/tmux. Si un TUI ancien renvoie des séquences bizarres, désactiver dans `.wezterm.lua`.

## Config

- Fichier : `~/.wezterm.lua` (lien symbolique → [`conf/wezterm/.wezterm.lua`](../conf/wezterm/.wezterm.lua))
- Plugins (cloned par WezTerm) : `~/Library/Application Support/wezterm/plugins/`
- Voir tous les plugins installés : dans le debug overlay (`Ctrl+Shift+L` natif WezTerm), `wezterm.plugin.list()`

## Links

- Site : https://wezterm.org
- Repo : https://github.com/wez/wezterm
- Resurrect : https://github.com/MLFlexer/resurrect.wezterm
- Smart-splits : https://github.com/mrjones2014/smart-splits.nvim
