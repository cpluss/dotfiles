if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx PATH "/opt/homebrew/bin" $PATH

# === Prompt (starship instead of p10k recommended in Fish) ===
# Install starship: https://starship.rs
# Then enable it:
starship init fish | source

# === Aliases ===

alias gst="git status"
alias gl="git pull --rebase"
alias gc="git commit"
alias gca="git commit -a"
alias gp="git push"

# === Environment Variables ===
set -gx EDITOR nvim
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH $PYENV_ROOT/bin $PATH
set -gx PATH "/opt/homebrew/opt/rustup/bin" $PATH
set -gx PATH "$HOME/.cargo/bin" $PATH
set -gx PATH "$HOME/.local/bin" $PATH
set -gx PATH "$HOME/.bun/bin" $PATH
set -gx BUN_INSTALL "$HOME/.bun"

set -gx AWS_REGION "us-east-2"
set -gx AWS_DEFAULT_REGION "us-east-2"
set -gx DISABLE_PROMPT_CACHING 1
set -gx CLAUDE_CODE_USE_BEDROCK 1

# === Init Tools ===
# pyenv
if type -q pyenv
    pyenv init - | source
end

# direnv
direnv hook fish | source

# atuin
atuin init fish | source

if type -q nvm 
    nvm use latest
end

if test -f ~/.local/keys.fish
    source ~/.local/keys.fish
end

# bun completions
# test -f ~/.bun/_bun; and source ~/.bun/_bun

# Google Cloud SDK (zsh -> fish)
test -f ~/Downloads/google-cloud-sdk/path.fish.inc; and source ~/Downloads/google-cloud-sdk/path.fish.inc
test -f ~/Downloads/google-cloud-sdk/completion.fish.inc; and source ~/Downloads/google-cloud-sdk/completion.fish.inc

