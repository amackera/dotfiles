# pnpm
export PNPM_HOME="/Users/amackera/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(direnv hook zsh)"

# bun completions
[ -s "/Users/amackera/.bun/_bun" ] && source "/Users/amackera/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/Users/amackera/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# asdf version manager
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# OpenClaw Completion
source "/Users/amackera/.openclaw/completions/openclaw.zsh"
