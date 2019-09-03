create_clock -period 1.000 -name CLK [get_ports CLK]


set_property MARK_DEBUG false [get_nets {U7/O[0]}]
set_property MARK_DEBUG false [get_nets {U7/O[1]}]
