# dotfiles

Files mirror their location under `$HOME`.

| Path | What |
| --- | --- |
| `.config/nvim/` | Neovim (lazy.nvim; Elixir/Phoenix and React setup) |
| `.tmux.conf` | tmux |
| `.config/ghostty/` | Ghostty |
| `.zshrc`, `.zprofile` | zsh |
| `.gitconfig`, `.config/git/ignore` | git identity and global ignore |
| `.tool-versions` | asdf global versions |
| `Brewfile` | Homebrew packages the configs depend on |
| `install.sh` | Sets up a Mac from this repo |

Emacs config lives in its own repo: [amackera/emacs.d](https://github.com/amackera/emacs.d).

## Setting up a new Mac

```sh
git clone https://github.com/amackera/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The first `git` on a fresh Mac prompts to install the Xcode Command Line Tools; let that finish, then clone. The script assumes Apple Silicon (Homebrew at `/opt/homebrew`).

`install.sh` runs four steps. Each is safe to re-run, and you can run them individually, e.g. `./install.sh dotfiles`.

| Step | What it does |
| --- | --- |
| `brew` | Installs Homebrew if missing, trusts the emacs-plus tap, and installs everything in the `Brewfile`. |
| `dotfiles` | Copies the config files into `$HOME`. An existing file that differs is kept as `<name>.pre-dotfiles`. |
| `runtimes` | Adds the asdf plugins for `.tool-versions`, installs those versions, and installs Hex and rebar. Erlang and Python compile from source, so this takes a while. |
| `emacs` | Clones [amackera/emacs.d](https://github.com/amackera/emacs.d) to `~/.emacs.d` if it isn't there. |

Afterwards:

- Open a new shell, then run `gh auth login` and set up an SSH key for GitHub.
- Open `nvim`. The first launch bootstraps lazy.nvim, installs the plugins, and Mason pulls the language servers. Run `:Lazy restore` to get the exact plugin versions pinned in `lazy-lock.json`.
- Open Emacs and let it install its packages.

### Python

asdf provides the default `python3` for the shell. Python projects use [uv](https://docs.astral.sh/uv/), which downloads whatever version each project pins in `.python-version`, so nothing else needs installing up front. Tools installed with `uv tool install` land in `~/.local/bin`, which `.zshrc` puts on `PATH`.

### Caveats

- The files are copies, not symlinks. After changing a config in `$HOME`, copy it back here to keep the repo current.
- `.zshrc` references pnpm and bun, which the script does not install; both fail quietly if missing.
