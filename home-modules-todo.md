# Home Modules TODO — Missing Packages

Software with popular home-manager modules that is **not yet packaged** in
ekapkgs or corepkgs. Sorted by estimated user impact. Only includes items
that are services, have non-trivial configuration, or require setup.

## Tier 1 — Major desktop applications

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| firefox | program | Web browser | Profile/extension config, search engines, policies, user.js management |
| chromium | program | Web browser | Extension management, policies, command-line flags |
| vscode | program | Code editor | Extension list, settings.json, keybindings.json generation |
| vscodium | program | VS Code without telemetry | Same as vscode |
| neovim | program | Extensible editor (Vim fork) | Plugin management, init.lua generation, LSP wiring (neovim-unwrapped exists in corepkgs but the wrapped meta-package does not) |
| thunderbird | program | Email client | Account/profile config, extension management, policies |
| libreoffice | program | Office suite | Extension config, default format settings |

## Tier 2 — Popular Wayland/WM ecosystem tools

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| eww | program | Custom widget system (bars, panels) | Declarative yuck/scss config; heavily used with Hyprland |
| swaync | service | Wayland notification center | config.json + style.css generation, systemd user unit |
| swayosd | service | OSD for volume/brightness on Wayland | Service management, key binding integration |
| hyprpanel | program | Hyprland panel/bar | Configuration generation |
| quickshell | program | Qt-based widget toolkit for Wayland | Config generation |
| waybar | program | Wayland status bar | JSON config + CSS styling (package exists, home module missing) |
| walker | service | Wayland application launcher | Service + config management |

## Tier 3 — Developer tools

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| cursor | program | AI code editor (VS Code fork) | Settings/extension management |
| windsurf | program | AI code editor (Codeium) | Settings management |
| neovide | program | GPU-accelerated Neovim GUI | neovide-specific settings file |
| rio | program | GPU terminal emulator (Rust) | Config file generation |
| waveterm | program | AI-native terminal | Config management |
| poetry | program | Python dependency manager | Config/virtualenv management |
| ruff | program | Python linter/formatter | ruff.toml generation |
| sbt | program | Scala build tool | Plugin/config management |
| opam | program | OCaml package manager | Repo/switch config |

## Tier 4 — Chat, media, and gaming

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| qutebrowser | program | Vim-like browser | config.py generation, keybinding management |
| librewolf | program | Privacy-focused Firefox fork | Profile/policy management |
| element-desktop | program | Matrix chat client | Homeserver defaults, config generation |
| vesktop | program | Vencord-enhanced Discord client | Theme/config management |
| retroarch | program | Multi-system emulator frontend | Core management, controller/shader config |
| anki | program | Spaced-repetition flashcards | Plugin management |
| kodi | program | Media center | Addon management, sources, input mapping |
| prismlauncher | program | Minecraft launcher | Java/instance configuration |
| freetube | program | Private YouTube client | Config, subscription management |
| joplin-desktop | program | Note-taking app | Sync config, plugin management |

## Tier 5 — Services and daemons

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| espanso | service | Text expander | Match/config file management, user service |
| dropbox | service | Cloud file sync | User service, selective sync config |
| nextcloud-client | service | Self-hosted cloud sync | User service, folder sync settings |
| kdeconnect | service | Phone-desktop integration | User service management |
| activitywatch | service | Automated time tracker | Watcher config, user service |
| mullvad-vpn | program | Privacy VPN | Service config, auto-connect settings |
| onedrive | program | MS OneDrive sync | Sync config, selective sync |
| megasync | service | MEGA cloud sync | User service config |

## Tier 6 — Email and PIM workflow

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| mbsync (isync) | program+service | IMAP mailbox sync | Channel/account config generation; core of CLI email |
| offlineimap | program | IMAP mail sync | Account config generation |
| mu | program | Maildir indexer (mu4e) | Database config for Emacs email |
| notmuch | program | Mail indexer/tagger | Config + hook management |
| mblaze | program | Unix maildir utilities | Config generation |
| vdirsyncer | program+service | CalDAV/CardDAV sync | Account/collection config; essential for CLI calendars |
| khal | program | CLI calendar | Config generation, vdirsyncer integration |
| khard | program | CLI contact manager | Config generation, vdirsyncer integration |
| todoman | program | CLI todo manager | Config generation |

## Tier 7 — Music and media services

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| beets | program | Music library manager | Plugin config, import settings |
| mopidy | service | Extensible music server | Extension config, audio output |
| spotify-player | program | TUI Spotify client | Config/theme/keymap management |
| librespot | service | Spotify Connect daemon | Audio backend config, user service |
| obs-studio | program | Streaming/recording | Plugin management, scene config |
| jellyfin-mpv-shim | service | Jellyfin media playback | Service config |

## Tier 8 — Other notable gaps

| Package | Module type | Description | Why a home module matters |
|---------|------------|-------------|--------------------------|
| television | program | Fast fuzzy finder TUI | Config/picker management |
| skim | program | Fuzzy finder (fzf alternative) | Shell integration config |
| halloy | program | IRC client (Rust) | Config/theme management |
| dbeaver | program | Universal database GUI | Connection config |
| ludusavi | service | Game save backup | Service config, game path management |
| safeeyes | service | Break reminder | Service/interval config |
| onlyoffice | program | Office suite (MS compat) | Plugin config |
