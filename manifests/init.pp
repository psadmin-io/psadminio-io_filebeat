class io_filebeat (
  $ensure                    = hiera('ensure', 'present'),
  $psft_install_user_name    = hiera('psft_install_user_name', undef),
  $oracle_install_group_name = hiera('oracle_install_group_name', undef),
  $domain_user               = hiera('domain_user', undef),
  $pia_domain_list           = hiera_hash('pia_domain_list', undef),
  $appserver_domain_list     = hiera_hash('appserver_domain_list', undef),
  $prcs_domain_list          = hiera_hash('prcs_domain_list', undef),
  $major_version              = '6.4.2',
  $weblogic                  = false,
  $pia_access                = false,
  $pia_servlet               = false,
  $appserv                   = false,
  $gh_activity               = false,
  $gh_unmask                 = false,
  $prcs_logs                 = false,
  $fields                    = undef,
  $output                    = undef,
  $exclude_lines             = '[]',
) {

  # contain ::filebeat

  # if $pia_domain_list { validate_hash($pia_domain_list) }
  # if $appserver_domain_list { validate_hash($appserver_domain_list) }
  # if $prcs_domain_list { validate_hash($prcs_domain_list) }

  case $::osfamily {
    'windows': {
      $fileowner       = $domain_user
      $config_dir      = 'C:/Program Files/Filebeat/conf.d'
    }
    'AIX': {
      $fileowner       = $psft_install_user_name
    }
    'Solaris': {
      $fileowner       = $psft_install_user_name
    }
    default: {
      $fileowner       = $psft_install_user_name
      $config_dir      = '/opt/filebeat/conf.d'
    }
  }

  class { 'filebeat': 
    config_dir     => $config_dir,
    major_version  => $major_version,
    outputs        => $output,
    purge_conf_dir => false,
  }

  if ($weblogic) {
    contain ::io_filebeat::weblogic
  }
  if ($pia_access) {
    contain ::io_filebeat::pia_access
  }  
  if ($pia_servlet) {
    contain ::io_filebeat::pia_servlet
  }
  if ($gh_activity) {
    contain ::io_filebeat::gh_activity
  }
  if ($gh_unmask) {
    contain ::io_filebeat::gh_unmask
  }

}
