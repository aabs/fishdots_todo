#!/usr/bin/env fish

function _t -d 'invoke underlying task manager'
  task $argv[1..-1]
end
