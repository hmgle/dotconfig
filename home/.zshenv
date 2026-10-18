skip_global_compinit=1
. "$HOME/.cargo/env"

# ZVM
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Step checks this environment variable before persisting PATH to shell files.
# Keep it here so noninteractive zsh commands also inherit the opt-out.
export STEP_NO_MODIFY_PATH=1
case ":$PATH:" in
  *":$HOME/.stepcode/bin:"*) ;;
  *) export PATH="$HOME/.stepcode/bin:$PATH" ;;
esac
case ":$PATH:" in
  *":$HOME/.stepcode/agent/bin:"*) ;;
  *) export PATH="$HOME/.stepcode/agent/bin:$PATH" ;;
esac
