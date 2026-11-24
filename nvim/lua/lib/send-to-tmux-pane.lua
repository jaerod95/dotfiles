-- Runs a shell command in the pane to the right, splitting the window first if it has only one pane.
return function(command, opts)
  opts = opts or {}
  local focus = opts.focus and "; tmux select-pane -t 2" or ""
  vim.fn.system(
    "tmux list-panes | wc -l | grep -q 2 || (tmux split-window -h && tmux select-pane -t 1); tmux send-keys -t 2 "
      .. vim.fn.shellescape(command)
      .. " C-m"
      .. focus
  )
end
