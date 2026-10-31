## Previews

  > Preview 1
![Neovim Preview 1](preview/preview1.png)

  > Preview 2
![Neovim Preview 2](preview/preview2.png)

<!-- # Neovim -->
## Installation
 > Install requires Neovim nightly but might works on latest stable release. Always review the code before installing a configuration.

 > Make sure you delete or backup your old neovim configuration to somewhere safe before installing this one.


### Backup for linux & MacOS

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

### Backup for Windows

```bash
# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
```

### Installation for Linux & MacOS

```bash
git clone git@github.com:enesuzun2002/nvim.git ~/.config/nvim
```

### Installation for Windows

```bash
git clone git@github.com:enesuzun2002/nvim.git $env:LOCALAPPDATA\nvim
```

## Keybindings

The leader key is the **Space bar** (`vim.g.mapleader = " "` in `init.lua`). Any binding written as `<leader>xx` below means: press `Space`, then `xx` — e.g. `<leader>rr` = `Space` + `r` + `r`. Custom mappings below (`require("nvchad.mappings")` in `lua/mappings.lua` provides the NvChad defaults on top).

  > What's *not* here: no DAP debugger keymaps are bound (`debugger = { enabled = false, run_via_dap = false }` in flutter-tools), and most `<leader>r*` / `<leader>c*` / `<leader>k*` keys only do something when the matching SDK or tool is installed and you're in a project of that type.

### General & Editing

| Key | Modes | Description |
| --- | --- | --- |
| `;` | normal | Enter command mode (instead of `:`) |
| `jk` | insert | Exit insert mode |
| `gd` | normal | Go to definition (LSP) |
| `<A-a>` | normal | LSP code action |
| `<A-j>` / `<A-k>` | normal, insert, visual | Move line(s) down / up (with re-indent) |
| `<leader>tt` | normal | Toggle background transparency |
| `<A-i>` | normal, terminal | Toggle floating terminal (0.5×0.5 centered) |

### Files, Projects & Git

| Key | Description |
| --- | --- |
| `<leader>fr` | Recent files (Telescope, hidden files included) |
| `<leader>fp` | Find projects (project.nvim, detection via `.git` / `melos.yaml`) |
| `<leader>fc` | Find files inside the Neovim config |
| `<leader>gg` | Lazygit |
| `<C-b>c` / `<C-b>n` / `<C-b>p` / `<C-b>x` / `<C-b>&` | Tmux-style tabs: new / next / previous / close / close |
| `nvim-tree` | `l` / `<CR>` open, `h` go up a directory (node_modules, build, dist, etc. are hidden) |

### Flutter / Dart (dart files; SDK resolved from `~/Projects/flutter/sdk/flutter`, falls back to `$PATH`)

| Key | Description |
| --- | --- |
| `<leader>rr` | Flutter Run |
| `<leader>rp` | **Profile-mode build & run** (plain `flutter run --profile`) |
| `<leader>rf` | Flutter Run with `<project>/dart_defines.release.json` via `--dart-define-from-file` — a menu picks the mode (debug = plain run, profile, release); warns if the file is missing |
| `<leader>ru` | Flutter Run with custom args — free-form prompt, nothing appended automatically; values containing spaces are split on whitespace by flutter-tools |
| `<leader>rd` | Flutter Debug |
| `<leader>re` | Flutter Emulators |
| `<leader>rv` | Flutter Devices |
| `<leader>rl` | Hot Reload |
| `<leader>rR` | Hot Restart |
| `<leader>rq` | Quit Flutter — stops the session started from Neovim; if none exists (e.g. app was started before a restart), kills any orphaned `flutter run` process instead |
| `<leader>ro` | Toggle Flutter outline |
| `<leader>rL` / `<leader>rc` | Toggle / clear dev log |
| `<leader>ra` | Attach to running app |
| `<leader>rt` | Start DevTools server (link is shown as a 10s notification) |
| `<leader>rb` | Open DevTools in the browser (`FlutterOpenDevTools`; needs the app running so the full VM service link is detected) |

  > Emulators launch with `--enable-gpu-libvulkan --gpu host` and `QT_QPA_PLATFORM=xcb`.

### Go (go.nvim)

| Key | Description |
| --- | --- |
| `<leader>gtr` | Run test for current function |
| `<leader>gtf` | Run all tests in file |
| `<leader>gtp` | Run all tests in package |
| `<leader>gtc` | Toggle test coverage signs |
| `<leader>gr` | Go Run Project |
| `<leader>gs` | Go Stop Project |

### Rust (via cargo, in floating terminal)

| Key | Description |
| --- | --- |
| `<leader>cr` | `cargo run` |
| `<leader>ct` | `cargo test` |
| `<leader>cc` | `cargo check` |

### Gradle / Spring Boot & Amper

| Key | Description |
| --- | --- |
| `<leader>gr` | Run Gradle project (`./gradlew run`, or `bootRun` if Spring Boot is detected via `gradlew`) |
| `<leader>kb` / `<leader>ar` / `<leader>at` | Amper: build / run app / test |
| `<leader>ks` / `<leader>km` / `<leader>kd` | Amper: show settings / modules / dependencies |
| `<leader>kc` | Amper: clean build |

### Other Commands

- `Trouble` — diagnostics list (hints filtered out)
- `Lazy` — plugin manager
- `FlutterRun [args]`, `FlutterDebug [args]`, `FlutterEmulators`, `FlutterDevices`, `FlutterReload`, `FlutterRestart`, `FlutterQuit`, `FlutterOutlineToggle`, `FlutterLogToggle`, `FlutterLogClear`, `FlutterAttach [args]`, `FlutterDevTools` — flutter-tools user commands used by the mappings above; extra CLI args typed after the command are forwarded to `flutter run` (e.g. `:FlutterRun --profile --dart-define-from-file=dart_defines.release.json`)

## Language support

LSP servers enabled in `lua/configs/lspconfig.lua`: html, cssls, nixd, ts_ts (with `@vue/typescript-plugin`), oxlint, tailwindcss, lua_ls, gopls, sqls, vue_ls, rust_analyzer (clippy on save), clangd — plus jdtls (Java 21 via `nvim-java`) and the Dart language server (flutter-tools).

Formatting on save (`conform.nvim`, falls back to LSP formatting): stylua (Lua), oxfmt (web/json), gofmt (Go), rustfmt (Rust), sqlfmt (SQL), tombi (TOML), clang-format (C++), alejandra (Nix), google-java-format (Java). Dart buffers are formatted by the LSP + 2-space indent.

### Language-specific notes

- **Nix (`nixd`)**: expects a flake with `nixosConfigurations.XyrelTenz` for NixOS/home-manager option completion
- **Java**: expects JDK 21 at `/usr/lib/jvm/default`, no auto install
- **Vue**: expects `@vue/typescript-plugin` in `/usr/lib/node_modules` and `vue-language-server` in `/usr/bin`
