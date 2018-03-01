function td
    $DOTFILES/tools/todo/todo.sh -N
end

function task
    set -l TODAY (date --iso-8601)
    td add "$TODAY $argv[1]"
end

abbr --add did 'td do' # add line number of task
abbr --add tasks 'td list'
abbr --add contexts 'td lsc'
