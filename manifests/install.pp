#Install OHS 11g
class ohs::install {

$response_dir                       =hiera('response_dir')

#default 
$ohs_default_port                   =hiera('ohs_default_port', '8888')
$ohs_default_proxy_port             =hiera('ohs_default_proxy_port', '4443')
$ohs_default_ssl_port               =hiera('ohs_default_ssl_port', '8443')
$ohs_default_instance_name          =hiera('ohs_default_instance_name', 'test')
$ohs_install_dir                    =hiera('ohs_install_dir', '')

  File {
    owner => 'oracle',
    group => 'oinstall',
    mode  => '0755',
  }

  file {'response_dir' :
    ensure  => directory,
    path    => $response_dir,
    replace => false,
  }

  file {'ohs_response_file' :
    ensure  => file,
    path    => "${response_dir}/ohs_response.rsp",
    content => template("${module_name}/ohs_response.rsp.erb"),
    replace => false,
  }

  file {'ohs_staticports' :
    ensure  => file,
    path    => "${response_dir}/staticports.ini",
    content => template("${module_name}/staticports.ini.erb"),
    replace => false,
  }

  exec {'ohs_installer' :
    cwd         => $ohs_install_dir,
    path        => '/bin/:/usr/bin:/usr/local/bin',
    command     => 'sh ohs_installer.sh',
    creates     => '/u01/app/oracle/middleware/ohs/dummy.ssl.txt',
    require     => [File['ohs_response_file'], Class['ohsint::required_files'], File ['ohs_inventory_home'] ],
    user        => 'oracle',
    logoutput   => true,
  }
}
