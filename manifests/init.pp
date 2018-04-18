class io_filebeat (
  $ensure                    = hiera('ensure', 'present'),
  $psft_install_user_name    = hiera('psft_install_user_name', undef),
  $oracle_install_group_name = hiera('oracle_install_group_name', undef),
  $domain_user               = hiera('domain_user', undef),
  $pia_domain_list           = hiera_hash('pia_domain_list', undef),
  $appserver_domain_list     = hiera_hash('appserver_domain_list', undef),
  $prcs_domain_list          = hiera_hash('prcs_domain_list', undef),
  $config_dir                = '/opt/filebeat/conf.d',
  $major_version              = '5.4.0',
  $weblogic                  = false,
  $pia_access                = false,
  $appserver                 = false,
  $prcs                      = false,
  $fields                    = undef,
  $output                    = undef,
) {

  # contain ::filebeat

  # if $pia_domain_list { validate_hash($pia_domain_list) }
  # if $appserver_domain_list { validate_hash($appserver_domain_list) }
  # if $prcs_domain_list { validate_hash($prcs_domain_list) }

  case $::osfamily {
    'windows': {
      $fileowner       = $domain_user
    }
    'AIX': {
      $fileowner       = $psft_install_user_name
    }
    'Solaris': {
      $fileowner       = $psft_install_user_name
    }
    default: {
      $fileowner       = $psft_install_user_name
    }
  }

  class { 'filebeat': 
    config_dir     => $config_dir,
    major_version  => $major_version,
    outputs        => $output,
  }

  if ($weblogic) {
    contain ::io_filebeat::weblogic
  }
  if ($pia_access) {
    contain ::io_filebeat::pia_access
  }
  if ($appserver) {
    contain ::io_filebeat::appserver
  }

}
