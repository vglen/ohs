OHS
==============
A puppet module for installing OHS. You can install a single instance or multiple ones utilizing hiera.

##Notes
This is the inital release. I left out the opmn.xml.erb file, but you can put one in and utilize the following values in hiera:

	local_port
	remote_port

    <port local="<%= @local_port %>" remote="<%= @remote_port %>"/>

The default install will use 6700 and 6701. If you run the multiple instances or add an instance with the default one off, you will end up with port overlaps for opmn.

This config is using OHS for OSSO and proxying down to a WebLogic Host, but can be altered to be used as a reverse proxy or something else entirely.

##Requirements
Hiera.
Installation media. We use autofs and mount via the cwd in the exec.

##Usage
An example of how to create mutliple instances via hiera:

	ohs_instances:
  		instance1:
    		name: 'instance1'
    		port: '7798'
    		ssl_port: '8898'
    		proxy_port: '4498'
    		local_port: '6700'
    		remote_port: '6701'
    		wl_host: 'myhost.domain'
    		wl_port: '8701'
    		wl_log_file: '/DIR/tmp/weblogic.log'
    		wl_url: 'APP'
    		osso_file: 'host.osso.conf'
  		instance2:
  			name: 'instance2'
    		port: '7799'
    		ssl_port: '8899'
    		proxy_port: '4499'
    		local_port: '6702'
    		remote_port: '6703'
    		wl_host: 'myhost.domain'
    		wl_port: '8701'
    		wl_log_file: '/DIR/tmp/weblogic.log'
    		wl_url: 'APP'
    		osso_file: 'host.osso.conf'

Simply remove instance2 from hiera for a single config. This module will install the default instance which can be removed after or simply turned down with opmnctl.

   
