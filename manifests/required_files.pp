# OraInventory and Init Script
class ohs::required_files {

  $ohs_inv_loc            =hiera('ohs_inv_loc', '/opt/oraInventory')
  $ohs_inst_grp           =hiera('ohs_inst_grp', 'oracle_group')

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file {'ohs_inventory_etc' :
    ensure  => present,
    path    => '/etc/oraInst.loc',
    content => template("${module_name}/oraInst.loc.erb"),
    replace => false,
  }

  file {'ohs_inventory_home' :
    ensure  => present,
    path    => '/home/oracle/oraInst.loc',
    content => template("${module_name}/oraInst.loc.erb"),
    replace => false,
  }
}


