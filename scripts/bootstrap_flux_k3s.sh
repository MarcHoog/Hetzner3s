#!/usr/bin/env bash
set -euo pipefail

readonly INTERACTIVE=$([ -t 0 ] && echo true || echo false)

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

prompt() {
  local var_name=$1   # name of the variable to set
  local prompt_text=$2
  local default=${3:-}
  local value

  if [[ -n "${!var_name:-}" ]]; then
    return 0
  fi

  if [[ $INTERACTIVE == true ]]; then
    if [[ -n $default ]]; then
      read -rp "$prompt_text [$default]: " value
      value=${value:-$default}
    else
      read -rp "$prompt_text: " value
    fi
    printf -v "$var_name" '%s' "$value"
  else
    echo "❌ Error: \$${var_name} not set and no TTY to prompt." >&2
    exit 1
  fi
}

prompt GH_OWNER   "Enter GitHub owner (user or org)"
prompt GH_REPO    "Enter repository name"
prompt GH_BRANCH  "Enter branch to track" "main"
prompt IS_PRIVATE "Is the repository private? (y/N)" "n"
prompt GH_PATH    "Enter repo path to flux manifests" "."

if ! command -v flux &> /dev/null; then
  echo "🚀 Installing Flux CLI..."
  curl -s https://fluxcd.io/install.sh | sudo bash
else
  echo "✅ Flux CLI already installed."
fi

# --- Bootstrap Flux ---
echo "📦 Bootstrapping Flux into cluster..."

# Build common args
bootstrap_args=(
  github
  --owner="$GH_OWNER"
  --repository="$GH_REPO"
  --branch="$GH_BRANCH"
  --path="$GH_PATH"
  --personal
)

if [[ "${IS_PRIVATE,,}" == "y" ]]; then
  bootstrap_args+=( --private=true --token-auth --token="$GH_TOKEN" )
else
  bootstrap_args+=( --private=false )
fi

# Run the bootstrap command
flux bootstrap "${bootstrap_args[@]}"

echo "🎉 Flux has been successfully bootstrapped from '$GH_OWNER/$GH_REPO' (branch: $GH_BRANCH, path: $GH_PATH)."