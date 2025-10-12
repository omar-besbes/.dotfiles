#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

[ ! -v DOTFILES_ROOT_DIR ] && source "$HOME/.dotfiles/scripts/utils.sh"

REPO="https://github.com/omar-besbes/.dotfiles"
WORKFLOW_NAME="Build remastered ISO"
ENV_NAME="build-iso-image"
ISO_ARCH="amd64"
ISO_TYPE="netinst"
DEBIAN_BRANCH="stable"
ARTIFACT_NAME="remastered-iso"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

  # update dependencies list
  execute "sudo apt-get update" "Updating ..."

  # install gnupg & jq
  execute "sudo apt-get install -y gnupg jq" "Installing gnupg ..."

  # Install GitHub CLI from official apt repo
  if ! cmd_exists gh; then
    execute '
      sudo mkdir -p -m 755 /etc/apt/keyrings
      OUT=$(mktemp)
      curl -fsSL -o "$OUT" https://cli.github.com/packages/githubcli-archive-keyring.gpg
      cat "$OUT" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
      sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
      sudo mkdir -p -m 755 /etc/apt/sources.list.d
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update
      sudo apt-get install -y gh
    ' "Installing GitHub CLI ..."
  fi

  # Auth if required
  if ! gh auth status &>/dev/null; then
    print_info "Logging into GitHub CLI for $REPO (scopes: repo, workflow) ..."
    gh auth login --web -s "repo,workflow" || {
      print_error "GitHub authentication failed"
      exit 1
    }
  fi
}

# ----------------------------------------------------------------------
# | ISO Build Orchestration                                            |
# ----------------------------------------------------------------------

iso_build() {

  local tmpdir="$(mktemp -d)"
  GNUPGHOME="$tmpdir/gnupg"
  mkdir -m 700 -p "$GNUPGHOME"

  execute '
    id="Dotfiles Ephemeral $(date +%s)"
    gpg --batch --quiet --passphrase "" --quick-generate-key "$id" rsa4096 encrypt 1d
    FINGERPRINT=$(gpg --batch --with-colons --fingerprint "$id" | grep -m1 "^fpr:" | cut -d: -f10)
    gpg --armor --export             "$FINGERPRINT" > "$tmpdir/pub.asc"
    gpg --armor --export-secret-keys "$FINGERPRINT" > "$tmpdir/priv.asc"
    gh secret set GPG_PUBLIC_KEY            -R "$REPO" -e "$ENV_NAME" < "$tmpdir/pub.asc"
    gh secret set GPG_RECIPIENT_FINGERPRINT -R "$REPO" -e "$ENV_NAME" -b "$FINGERPRINT"
  ' "Generating & Installing GPG keys in environment secrets ..."

  execute '
    inputs=( -f arch="$ISO_ARCH" -f type="$ISO_TYPE" -f branch="$DEBIAN_BRANCH" )
    gh workflow run "$WORKFLOW_NAME" -R "$REPO" "${inputs[@]}"
  ' "Dispatching workflow ..."

  execute '
    sleep 2
    run_id=$(gh run list -R "$REPO" --workflow "$WORKFLOW_NAME" --json databaseId,createdAt \
      --jq "max_by(.createdAt).databaseId" 2>/dev/null || true)
    [ -n "$run_id" ] || { print_error "Could not determine workflow run ID"; exit 1; }
    gh run watch -R "$REPO" --exit-status "$run_id"
    gh run download -R "$REPO" "$run_id" --name "$ARTIFACT_NAME" || {
      print_error "Failed to download artifact from run "#$run_id""
      exit 1
    }
  ' "Waiting for the run to finish ..."

  execute '
    gpg --import "$tmpdir/priv.asc" >/dev/null
    gpg --output "remastered.iso" --decrypt "$ARTIFACT_NAME"
  ' "Decrypting ISO ..."

  execute '
    gh secret delete GPG_PUBLIC_KEY            -R "$REPO" -e "$ENV_NAME" --yes || true
    gh secret delete GPG_RECIPIENT_FINGERPRINT -R "$REPO" -e "$ENV_NAME" --yes || true
  ' "Cleaning up GitHub secrets ..."

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  ask_for_sudo

  install_dependencies

  iso_build

  print_success "DONE. ISO at: $OUTDIR/remastered.iso"

}

main
