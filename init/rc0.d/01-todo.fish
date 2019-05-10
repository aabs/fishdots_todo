
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
      emit task_completed $argv[2]
    case home
      emit task_home
    case ls
      emit task_list
    case pls
      emit task_list_project
    case new
      emit task_new $argv[2] $argv[3..-1]
    case pnew
      emit task_project_new $argv[2] $argv[3..-1]
    case sync
      emit task_sync
    case recent
      emit task_recent
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
  t_option 'pls' 'list all tasks' 
  t_option 'new' 'create a new task' 
  t_option 'pnew' 'create a new task tagged by current project' 
  t_option 'sync' 'push all tasks to repo' 
  t_option 'recent' 'get recently completed tasks (from last 24 hrs)'
end

complete -c t -x -a 'did' -d 'mark task as complete' 
complete -c t -x -a 'home' -d 'cd to the task root folder' 
complete -c t -x -a 'ls' -d 'list all tasks' 
complete -c t -x -a 'pls' -d 'list all tasks' 
complete -c t -x -a 'new' -d 'create a new task' 
complete -c t -x -a 'pnew' -d 'create a new task tagged by current project' 
complete -c t -x -a 'sync' -d 'push all changes to repo' 
complete -c t -x -a 'recent' -d  'get recently completed tasks (from last 24 hrs)'

function t_option -a name desc -d 'helper function for displaying usage info'
  colour_print cyan 't '
  colour_print green "$name "
  colour_print normal "$desc"
  echo; echo
end

function t_did -e task_completed -a taskno
  task $taskno done
end

function t_home -e task_home -d 'go to task dir'
  cd ~/.task
end

function t_create -e task_new -a title
  task add "$title" $argv[2..-1]
end

function t_project_create -e task_project_new -a title -d 'create a task tagged to the current project'
  task add "$title" "pro:$CURRENT_PROJECT_SN" $argv[2..-1]
end

function t_list -e task_list
  _t list
end

function t_recent -e task_recent -d 'get recently completed tasks (from last 24 hrs)'
  task end.after:now-48h completed 
end

function t_project_list -e task_list_project
  _t "pro:$CURRENT_PROJECT_SN" list 
end


function t_sync -e task_sync -d 'synchronise tasks repo'
  fishdots_git_sync ~/.task "wip"
end
