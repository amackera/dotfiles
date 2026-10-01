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

Emacs config lives in its own repo: [amackera/emacs.d](https://github.com/amackera/emacs.d).

## Setting up a new Mac

1. Install Homebrew and the tools the configs expect. `.zprofile` assumes Homebrew at `/opt/homebrew` (Apple Silicon).

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   brew install git gh neovim tmux direnv asdf ripgrep fzf tree-sitter-cli
   brew install --cask ghostty font-fira-code
   ```

2. Clone this repo and copy the files into `$HOME`.

   ```sh
   git clone https://github.com/amackera/dotfiles.git ~/dotfiles
   rsync -av --exclude .git --exclude README.md ~/dotfiles/ ~/
   ```

3. Install the language runtimes listed in `.tool-versions`.

   ```sh
   asdf plugin add erlang && asdf plugin add elixir && asdf plugin add nodejs
   cd ~ && asdf install
   ```

4. Open `nvim`. The first launch bootstraps lazy.nvim, installs the plugins, and Mason pulls the language servers. Run `:Lazy restore` to get the exact plugin versions pinned in `lazy-lock.json`.

5. Clone the Emacs config.

   ```sh
   git clone https://github.com/amackera/emacs.d.git ~/.emacs.d
   ```

### Caveats

- The files are copies, not symlinks. After changing a config in `$HOME`, copy it back here to keep the repo current.
- `.zshrc` has several hardcoded `/Users/amackera/...` paths, so it only works as-is with the same username.
- `.zshrc` also references pnpm and bun; both fail quietly if missing.
