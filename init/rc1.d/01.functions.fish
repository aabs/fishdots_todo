
# mnemonics:
#   a: add/new
#     p: project scope
#   l: list
#     p: project scope
#     n: list by priority order
#   d: did
#   r: report
#     t: tags
#     p: projects
#     b: burndown
#       d: daily (if after b)
#       w: weekly (if after b)

function t -d 'main dispatcher function for fishdots todo'
  if test 0 -eq (count $argv)
    t_help
    return
  end
  switch $argv[1]
    case rbd
      emit task_report_daily_bd
    case rbw
      emit task_report_weekly_bd
    case rt
      emit task_report_tags
    case rp
      emit task_report_projects
    case ln
      emit task_report_priority
    case lnp
      emit task_report_priority_for_current_project
    case d
      emit task_completed $argv[2]
    case did
      emit task_completed $argv[2]
    case h
      emit task_home
    case home
      emit task_home
    case l
      emit task_list
    case lp
      emit task_list_project
    case a
      emit task_new $argv[2] $argv[3..-1]
    case add
      emit task_new $argv[2] $argv[3..-1]
    case new
      emit task_new $argv[2] $argv[3..-1]
    case ap
      emit task_project_new $argv[2]
    case s
      emit task_sync
    case sync
      emit task_sync
    case rs
      emit task_recent
    case '*'
      t_help
  end
end

function t_help -d "display usage info"
  echo "Fishdots Tasks Usage"
  echo "===================="
  echo "t <command> [args]"
  echo ""
  echo "
Mnemonics:
  h: home
  a: add/new
    p: project scope
  l: list
    p: project scope
    n: list by priority order
  d: did
  r: report
    s: standup
    t: tags
    p: projects
    b: burndown
      d: daily (if after b)
      w: weekly (if after b)
  
  "
end

complete -c t -x -a 'd' -d 'mark task as complete' 
complete -c t -x -a 'h' -d 'cd to the task root folder' 
complete -c t -x -a 'l' -d 'list all tasks' 
complete -c t -x -a 'lp' -d 'list all project tasks' 
complete -c t -x -a 'ln' -d 'list all tasks by priority order' 
complete -c t -x -a 'a' -d 'create a new task' 
complete -c t -x -a 'ap' -d 'create a new task tagged by current project' 
complete -c t -x -a 'sync' -d 'push all changes to repo' 
complete -c t -x -a 'rs' -d  'standup report - recently closed'
complete -c t -x -a 'rt' -d  'list all tags'
complete -c t -x -a 'rp' -d  'list projects'
complete -c t -x -a 'rbd' -d  'daily burndown report'
complete -c t -x -a 'rbw' -d  'weekly burndown report'

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
  task add "$title" $argv[3..-1]
end

function t_project_create -e task_project_new -a title -d 'create a task tagged to the current project'
  task add "$title" "pro:$CURRENT_PROJECT_SN" "pri:M"
end

function t_list -e task_list
  task min
end

function t_recent -e task_recent -d 'get recently completed tasks (from last 24 hrs)'
  task end.after:now-48h completed 
end

function t_project_list -e task_list_project
  task "pro:$CURRENT_PROJECT_SN" list 
end

function trp -e task_report_projects
  task projects
end

function trbd -e task_report_daily_bd
  task burndown.daily
end

function trbw -e task_report_weekly_bd
  task burndown.weekly
end

function trt -e task_report_tags
  task tags
end

function tpri -e task_report_priority -d 'display list of tasks muth most important first'
  task ready
end

function t_sync -e task_sync -d 'synchronise tasks repo'
  fishdots_git_sync ~/.task "wip"
end

function tlnp -e  task_report_priority_for_current_project
  task "project:$CURRENT_PROJECT_SN" next
end
