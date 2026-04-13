#!/usr/bin/env bash
# Fuzzy-find tmux keybindings and execute the selected one
# Bound to <prefix>? in tmux.conf

fullkeys=$(mktemp)
notes=$(mktemp)
trap 'rm -f "$fullkeys" "$notes"' EXIT

tmux list-keys > "$fullkeys"

# Build notes lookup: "table:key\tdescription"
for table in prefix root copy-mode copy-mode-vi; do
  tmux list-keys -N -T "$table" 2>/dev/null | awk -v t="$table" '{
    gsub(/^[[:space:]]+/, "")
    idx = match($0, /  +/)
    if (idx > 0) {
      key = substr($0, 1, idx - 1)
      desc = substr($0, idx)
      gsub(/^[[:space:]]+/, "", desc)
      printf "%s:%s\t%s\n", t, key, desc
    }
  }'
done > "$notes"

green=$'\033[32m'
dim=$'\033[2m'
reset=$'\033[0m'

selected=$(awk -v green="$green" -v dim="$dim" -v reset="$reset" '
FILENAME == ARGV[1] {
  idx = index($0, "\t")
  if (idx > 0) {
    note[substr($0, 1, idx - 1)] = substr($0, idx + 1)
  }
  next
}
{
  has_r = ($2 == "-r") ? 1 : 0
  table = has_r ? $4 : $3
  key = has_r ? $5 : $4
  start = has_r ? 6 : 5
  cmd = ""
  for (i = start; i <= NF; i++) cmd = (cmd) (i > start ? " " : "") $i

  if (table == "prefix") dk = "C-a " key
  else if (table == "root") dk = key
  else if (table == "copy-mode-vi") dk = "[vi] " key
  else if (table == "copy-mode") dk = "[cp] " key
  else dk = "[" table "] " key

  lookup = table ":" key
  if (lookup in note) {
    desc = note[lookup]
    printf "%s%-20s%s  │  %s\t%s\t%s\n", green, dk, reset, desc, table, key
  } else {
    printf "%s%-20s%s  │  %s%s%s\t%s\t%s\n", green, dk, reset, dim, cmd, reset, table, key
  }
}
' "$notes" "$fullkeys" | \
  fzf --prompt="tmux keys > " \
      --header="enter: execute  esc: cancel" \
      --layout=reverse \
      --no-sort \
      --ansi \
      --delimiter='\t' \
      --with-nth=1)

[[ -z "$selected" ]] && exit 0

table=$(printf '%s' "$selected" | cut -f2)
actual_key=$(printf '%s' "$selected" | cut -f3)

cmd=$(awk -v table="$table" -v key="$actual_key" '
{
  has_r = ($2 == "-r") ? 1 : 0
  t = has_r ? $4 : $3
  k = has_r ? $5 : $4
  start = has_r ? 6 : 5
  if (t == table && k == key) {
    cmd = ""
    for (i = start; i <= NF; i++) cmd = (cmd) (i > start ? " " : "") $i
    print cmd
    exit
  }
}' "$fullkeys")

[[ -n "$cmd" ]] && echo "$cmd" | tmux source-file /dev/stdin
