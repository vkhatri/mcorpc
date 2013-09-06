require 'rubygems'
require 'mcollective'

include MCollective::RPC

class MCORPC
  attr_reader :mco

  def conn(agent)
    # Initialize rpcclient connection for agent
    mc = rpcclient(agent)
    mc.reset_filter 
    mc.timeout = 60
    # Set -T global
    mc.collective = 'global'
    # Disable Progress bar
    mc.progress = false
    mc.verbose = false
    @mco = mc
  end

  def close
    # Close rpcclient connection
    @mco.disconnect
  end

  def reset_filter
    # Reset Filters
    @mco.reset_filter
  end

  def mcocmd(host,cmd)
    # shellcmd agent to execute commands
    conn("shellcmd")  
    value = nil
    # MCO filter for -F hostname='hostname'
    mco.fact_filter "hostname",host
    mco.discover :verbose => false
    response = mco.runcmd(:cmd => cmd)
    response.each { |a| value = a.results[:data][:stdout]}
    return value
  end

  def mcohostfact(host,fact)
    # facts agent to get fact value for a host 
    conn("rpcutil")   
    value = nil
    mco.fact_filter "hostname", host
    mco.discover :verbose => false
    response = mco.get_fact(:fact => fact)
    response.each { |a| value = a.results[:data][:value]}
    return value
  end

  def mcodiscovernode(facts,classes=nil)
    # find agent to discover hosts
    conn("rpcutil")  
    value = nil
    facts = facts.split(",")
    # Set fact discovery
    facts.each { |f|
      factName,factValue = f.split("=")
      mco.fact_filter factName, factValue
    }
    #Set class discovery
    if classes
      classes = classes.split(",")
      classes.each {|classname|  
        mco.class_filter classname
      }
    end
    mco.discover :verbose => false
    value = mco.discover
    return value
  end

  def mcodiscoverfact(fact,facts,classes=nil)
    # facts agent to search fact value
    conn("rpcutil")  
    value = nil
    facts = facts.split(",")
    # Set fact discovery
    facts.each { |f|
      factName,factValue = f.split("=")
      mco.fact_filter factName, factValue
    }
    #Set class discovery
    if classes
      classes = classes.split(",")
      classes.each {|classname|  
        mco.class_filter classname
      }
    end
    mco.discover :verbose => false
    response = mco.get_fact(:fact => fact)
    response.each { |a| 
      value = []
      value.push  a.results[:data][:value] 
      value = value.uniq
    }
    return value
  end

end
