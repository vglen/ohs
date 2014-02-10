#Used to create multiple OHS Internal instances
define ohs::instance_info (
  $port,
  $proxy_port,
  $ssl_port,
  $name,
  $ohsint_base = '<DIR>/ohs/instances',
  $local_port,
  $remote_port,
  $wl_host,
  $wl_port,
  $wl_log_file,
  $wl_url,
  $osso_file,
){

  Exec {
    provider  => 'shell',
    user      => 'oracle_user',
    logoutput => true,
  }

  File {
    owner => 'oracle_user',
    group => 'oracle_group',
    mode  => '0600',
  }


  exec {"create_instance-${name}":
    cwd     => '<DIR>/ohs/opmn/',
    command => "./bin/opmnctl createinstance -oracleInstance ${ohsint_base}/${name} -adminRegistration OFF",
    creates => "${ohsint_base}/${name}/bin/opmnctl",
    notify  => Exec["create_component_${name}"],
  }

  exec {"create_component_${name}":
    command     => "${ohsint_base}/${name}/bin/opmnctl createcomponent -componentType OHS -componentName OHS1 -listenPort ${port} -sslPort ${ssl_port} -proxyPort ${proxy_port}",
    refreshonly => true,
  }

  file {"${ohsint_base}/${name}/config/OPMN/opmn/opmn.xml":
    ensure  => file,
    content => template("${module_name}/opmn.xml.erb"),
    require => Exec["create_component_${name}"],
  }

  file {'/u01/tmp':
    ensure => directory,
    mode   => '0775',
  }

  file {"${ohsint_base}/${name}/config/OHS/OHS1/mod_wl_ohs.conf":
    ensure  => file,
    content => template("${module_name}/mod_wl_ohs.conf.erb"),
    notify  => Service["ohs_init_${name}"],
  }

  file {"/etc/init.d/ohs_init_${name}":
    ensure  => file,
    content => template("${module_name}/ohs_init.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file {"${ohsint_base}/${name}/config/OHS/OHS1/${osso_file}":
    ensure  => file,
    mode    => '0644',
    source  => "puppet:///modules/ohsint/${osso_file}",
    require => Exec["create_component_${name}"],
  }

  file {"${ohsint_base}/${name}/config/OHS/OHS1/moduleconf/mod_osso.conf":
    ensure  => file,
    content => template("${module_name}/mod_osso.conf.erb"),
    require => File["${ohsint_base}/${name}/config/OHS/OHS1/${osso_file}"],
  }

  service {"ohs_init_${name}":
    ensure  => running,
    enable  => true,
    require => File["/etc/init.d/ohs_init_${name}"],
  }

}


class ohsint::instances {

  $ohs_instances = hiera_hash('ohs_instances')

  create_resources ('ohsint::instance_info', $ohs_instances)
}
