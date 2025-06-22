## ✅ 1. Save the tmux-sessionizer Script

Create the script file:

```bash
mkdir -p ~/.local/scripts
nano ~/.local/scripts/tmux-sessionizer
```

Paste the following into the file:

```bash
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/Developer/personal ~/Developer/work ~/.config -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi
```

Modify the `find` line (line 6) to your preferred folders if different from `~/projects` and `~/tests`.

Make it executable:

```bash
chmod +x ~/.local/scripts/tmux-sessionizer
```

---

## ✅ 2. Add Script to Your Shell Configuration

### Inside `~/.zshrc`:

```bash
PATH="$PATH:$HOME/.local/scripts"
bindkey -s ^f "tmux-sessionizer\n"
```

Then restart your shell:

```bash
source ~/.zshrc
```

---

## ✅ 3. Add to Your `.tmux.conf`

Edit `~/.tmux.conf`:

```bash
# Bind <prefix>f to open sessionizer with fzf
bind-key -r f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"

# Optional: Jump directly to a specific project with <prefix>k
bind-key -r k run-shell "~/.local/scripts/tmux-sessionizer"
```

Then reload tmux config:

```bash
tmux source-file ~/.config/tmux/tmux.conf
```

---

## ✅ 4. How to Use

- Press `Ctrl+f` in your terminal (outside of tmux) to launch the project switcher via `fzf`.
- Inside tmux: use `<prefix>f` to open the fuzzy project selector.
- Press `<prefix>k` to jump directly to a specific project session.

---