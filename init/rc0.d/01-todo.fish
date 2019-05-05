function t
    task $argv[1..-1]
end

function t_create -a title
    set -l TODAY (date --iso-8601)
    td add "$TODAY $title $argv[2..-1]"
end

abbr --add did 'td do' # add line number of task
abbr --add tasks 'td list'
abbr --add contexts 'td lsc'
