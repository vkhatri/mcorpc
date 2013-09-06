mcorpc
======

Ruby Library to Use different mco agents


======
Connect to MCO:
======
require 'rubygems'
require 'mcorpc'

mcoconn = MCORPC.new


======
Find a fact value for a host using 'facts' agent:
======
hostname = 'hostname'
fact_name = 'fact'
fact_value = mcoconn.mcohostfact(hostname,'application')
puts fact_value


======
Execute a command using 'shellcmd' agent:
======
output = mcoconn.mcocmd(hostname,'uptime')
puts output


======
Find fact value for given fact(s):
======
search_fact = "application=/dhcp/,ec2_region=us-east-1"
search_class = "puppet_class"
fact_value = mcoconn.mcodiscoverfact(fact_name,search_fact,search_class)


======
Discover nodes using 'find' agent:
======
discovered_nodes = mcodiscovernode(search_fact,search_class)


