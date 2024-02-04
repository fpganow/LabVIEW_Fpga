#create_project -in_memory -part "xc7k410tffg900-2"

package require struct::list
package require struct::set
set_param synth.elaboration.rodinMoreOptions "rt::set_parameter reduceVariableBitSelect false; rt::set_parameter reinferPruneBitWidths false; rt::set_parameter constPropCarry false"

if { [llength $argv] == 0 || [lindex $argv 0] == "" } {
    set netgen_output_file ./xge_mac_wrapper.edf
    set src_dir .
} else {
    set netgen_output_file [lindex $argv 0]
    set src_dir [lindex $argv 1]
}

add_files ${src_dir}/xge
add_files ${src_dir}/xge_interface

synth_design -flatten_hierarchy rebuilt -top xge_mac_wrapper -part "xc7k410tffg900-2" -include_dirs ${src_dir}/xge/rtl/include

puts "# output file $netgen_output_file"
write_edif -force $netgen_output_file
