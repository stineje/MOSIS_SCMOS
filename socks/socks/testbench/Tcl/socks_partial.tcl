database -open socks_sim -shm -default
probe -shm : -all -variables
probe -shm :KS_top_inst:CoreInst:custom1 -all -variables -depth all
run -timepoint 200 us -absolute
database -close socks_sim
finish
