abbr --add did 't did' # add line number of task
abbr --add tasks 't ls'

function _t -d 'invoke underlying task manager'
  task $argv[1..-1]
end

function t
  if test 0 -eq (count $argv)
    t_help
    return
  end
  switch $argv[1]
    case did
        t_did $argv[2]
    case home
        t_home
    case ls
        t_list
    case new
        t_create $argv[2..-1]
    case sync
        t_sync
    case '*'
      t_help
  end
end

function t_help -d "display usage info"
  echo "Fishdots Tasks Usage"
  echo "===================="
  echo "t <command> [options] [args]"
  echo ""
  
  t_option 'did <Task No.>' 'mark task as complete' 
  t_option 'home' 'cd to the tasks root folder' 
  t_option 'ls' 'list all tasks' 
  t_option 'new' 'create a new task' 
  t_option 'sync' 'push all tasks to repo' 
end

complete -c t -x -a 'did' -d 'mark task as complete' 
complete -c t -x -a 'home' -d 'cd to the task root folder' 
complete -c t -x -a 'ls' -d 'list all tasks' 
complete -c t -x -a 'new' -d 'create a new task' 
complete -c t -x -a 'sync' -d 'push all changes to repo' 

function t_option -a name desc -d 'helper function for displaying usage info'
  colour_print cyan 't '
  colour_print green "$name "
  colour_print normal "$desc"
  echo; echo
end

function t_did -a taskno
  _t $taskno done
end

function t_home -d 'go to task dir'
  cd ~/.task
end

function t_create -a title
    set -l TODAY (date --iso-8601)
    td add "$TODAY $title $argv[2..-1]"
end

function t_list
  _t list
end


function t_sync -d 'synchronise tasks repo'
  fishdots_git_sync ~/.task "wip"
end
