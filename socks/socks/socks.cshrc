# Be sure to set the path to your LDV installation
# most LDV 3,4 or 5 versions should work
# 
# For IIT students this is done by cadence.ic.cshrc
#

#setenv LDV /import/cadence/ldv51qsr2
#set path = ($LDV/tools/bin $path)
#setenv LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:${LDV}/tools/lib:"

# Install the rtems package in /opt/rtems
# Either physically or with a symbolic link
# 
# For IIT students:
# Note that this path only works on skew and vulcan
#

set path = ($path /opt/rtems/bin)

