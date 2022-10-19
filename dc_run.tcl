set_app_var sh_continue_on_error false
if {![info exists D]} {
  echo "Usage: dc_shell -f dc_run.tcl -x 'set D top'"
  exit
}
set CURRENT_DESIGN ${D}
unset D

set_app_var search_path "$search_path ../../.lib"
set_app_var target_library "tcbn22ulpbwp7t35p140ssg0p72v0c_ccs.db"
set_app_var link_library "* $target_library"

analyze -format sverilog -vcs "-f file.lst"
elaborate "$CURRENT_DESIGN"

source ../../example.sdc
compile_ultra
