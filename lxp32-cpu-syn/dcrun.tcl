set_app_var sh_continue_on_error false
set CURRENT_DESIGN lxp32u_top

set_app_var search_path "$search_path .. ../../.lib"
set_app_var target_library "tcbn22ulpbwp7t35p140ssg0p72v0c_ccs.db"
set_app_var link_library "* $target_library"

analyze -autoread "../rtl"
elaborate "$CURRENT_DESIGN"

source $CURRENT_DESIGN.sdc
compile_ultra
