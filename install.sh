#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_ROOT=""
DRY_RUN=0
SKIP_PLUGINS=0
SKIP_SYSTEM=0

usage() {
	cat <<'EOF'
Usage: ./install.sh [options]

Options:
  -n, --dry-run       Show the actions without changing anything.
      --skip-plugins  Skip cloning zgen and tpm.
      --skip-system   Skip sudo-managed system files such as udev rules.
  -h, --help          Show this help message.
EOF
}

log() {
	printf '[dotconfig] %s\n' "$*"
}

run() {
	if (( DRY_RUN )); then
		printf '[dry-run]'
		printf ' %q' "$@"
		printf '\n'
		return 0
	fi
	"$@"
}

ensure_backup_root() {
	if [[ -n "$BACKUP_ROOT" ]]; then
		return
	fi

	BACKUP_ROOT="${HOME}/.dotconfig-backups/${TIMESTAMP}"
	run mkdir -p "$BACKUP_ROOT"
}

backup_path() {
	local target="$1"
	local relative_path destination

	ensure_backup_root

	if [[ "$target" == "$HOME/"* ]]; then
		relative_path="${target#"$HOME"/}"
	else
		relative_path="${target#/}"
	fi

	destination="${BACKUP_ROOT}/${relative_path}"
	run mkdir -p "$(dirname "$destination")"
	run mv "$target" "$destination"
	log "Backed up ${target} -> ${destination}"
}

ensure_link() {
	local source_rel="$1"
	local target="$2"
	local source_path="${REPO_ROOT}/${source_rel}"
	local current_link=""

	if [[ ! -e "$source_path" && ! -L "$source_path" ]]; then
		printf '[dotconfig] Missing source: %s\n' "$source_path" >&2
		exit 1
	fi

	run mkdir -p "$(dirname "$target")"

	if [[ -L "$target" ]]; then
		current_link="$(readlink "$target")"
		if [[ "$current_link" == "$source_path" ]]; then
			log "Unchanged ${target}"
			return
		fi
	fi

	if [[ -e "$target" || -L "$target" ]]; then
		backup_path "$target"
	fi

	run ln -sfn "$source_path" "$target"
	log "Linked ${target} -> ${source_path}"
}

install_home_tree() {
	local source_rel rel_path

	while IFS= read -r source_rel; do
		rel_path="${source_rel#home/}"
		ensure_link "$source_rel" "${HOME}/${rel_path}"
	done < <(
		cd "$REPO_ROOT"
		find home -mindepth 1 \( -type f -o -type l \) | LC_ALL=C sort
	)
}

install_bin_dir() {
	local source_dir="${REPO_ROOT}/bin"
	local target_dir="${HOME}/bin"
	local entry name

	if [[ -L "$target_dir" ]] && [[ "$(readlink "$target_dir")" == "$source_dir" ]]; then
		log "Unchanged ${target_dir}"
		return
	fi

	if [[ ! -e "$target_dir" ]]; then
		run ln -s "$source_dir" "$target_dir"
		log "Linked ${target_dir} -> ${source_dir}"
		return
	fi

	if [[ -d "$target_dir" ]]; then
		while IFS= read -r entry; do
			name="$(basename "$entry")"
			ensure_link "bin/${name}" "${target_dir}/${name}"
		done < <(find "$source_dir" -mindepth 1 -maxdepth 1 \( -type f -o -type l \) | LC_ALL=C sort)
		return
	fi

	backup_path "$target_dir"
	run ln -s "$source_dir" "$target_dir"
	log "Linked ${target_dir} -> ${source_dir}"
}

ensure_git_clone() {
	local url="$1"
	local target="$2"

	if (( SKIP_PLUGINS )); then
		log "Skipped plugin clone: ${target}"
		return
	fi

	if [[ -d "${target}/.git" ]]; then
		log "Unchanged ${target}"
		return
	fi

	if [[ -e "$target" || -L "$target" ]]; then
		backup_path "$target"
	fi

	run mkdir -p "$(dirname "$target")"
	run git clone "$url" "$target"
	log "Cloned ${url} -> ${target}"
}

install_udev_rule() {
	local source_path="${REPO_ROOT}/system/udev/80-keyboard.rules"
	local target_path="/etc/udev/rules.d/80-keyboard.rules"

	if (( SKIP_SYSTEM )); then
		log "Skipped system file: ${target_path}"
		return
	fi

	if [[ -e "$target_path" ]] && cmp -s "$source_path" "$target_path"; then
		log "Unchanged ${target_path}"
		return
	fi

	if (( DRY_RUN )); then
		log "Would install ${target_path} with sudo"
		return
	fi

	sudo install -m 0644 "$source_path" "$target_path"
	sudo udevadm control --reload-rules
	log "Installed ${target_path}"
}

parse_args() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-n|--dry-run)
				DRY_RUN=1
				;;
			--skip-plugins)
				SKIP_PLUGINS=1
				;;
			--skip-system)
				SKIP_SYSTEM=1
				;;
			-h|--help)
				usage
				exit 0
				;;
			*)
				printf 'Unknown option: %s\n\n' "$1" >&2
				usage >&2
				exit 1
				;;
		esac
		shift
	done
}

parse_args "$@"

LINKS=(
	"git_template|${HOME}/.git_template"
	"config/awesome/rc.lua|${HOME}/.config/awesome/rc.lua"
	"config/atuin/config.toml|${HOME}/.config/atuin/config.toml"
	"config/markdownlint/markdownlintrc|${HOME}/.markdownlintrc"
)

install_home_tree

for entry in "${LINKS[@]}"; do
	IFS='|' read -r source_rel target_path <<<"$entry"
	ensure_link "$source_rel" "$target_path"
done

install_bin_dir
ensure_git_clone "https://github.com/tarjoilija/zgen.git" "${HOME}/.zgen"
ensure_git_clone "https://github.com/tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
install_udev_rule

if [[ -n "$BACKUP_ROOT" ]]; then
	log "Backups saved to ${BACKUP_ROOT}"
fi

log "Install complete."
