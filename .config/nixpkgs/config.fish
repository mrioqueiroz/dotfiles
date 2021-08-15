set fish_greeting
starship init fish | source
zoxide init fish | source
navi widget fish | source

bind -k up 'history merge ; up-or-search'

function br
  set -l cmd_file (mktemp)
  if broot --outcmd $cmd_file $argv
    read --local --null cmd < $cmd_file
    rm -f $cmd_file
    eval $cmd
  else
    set -l code $status
    rm -f $cmd_file
    return $code
  end
end

direnv hook fish | source
