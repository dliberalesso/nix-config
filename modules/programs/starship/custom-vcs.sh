#!/usr/bin/env bash

if jj root --ignore-working-copy >/dev/null 2>&1; then
  jj log --revisions "heads(::@ & bookmarks())" --no-graph --ignore-working-copy --color always --template 'surround("on  ", "", bookmarks)'
else
  # starship module vcs
  starship module git_branch
  starship module git_commit
  starship module git_state
  starship module git_status
fi
