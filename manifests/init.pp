class io_filebeat (
  $ensure                    = hiera('ensure', 'present'),
  $psft_install_user_name    = hiera('psft_install_user_name', undef),
  $oracle_install_group_name = hiera('oracle_install_group_name', undef),
  $domain_user               = hiera('domain_user', undef),
  $pia_domain_list           = hiera_hash('pia_domain_list'),
  $appserver_domain_list     = hiera_hash('appserver_domain_list'),
  $prcs_domain_list          = hiera_hash('prcs_domain_list'),
  $web_logs                  = undef,
  $access_logs               = undef,
  $app_logs                  = undef,
  $prcs_logs                 = undef,
  $fields                    = undef,
) {

  if $pia_domain_list { validate_hash($pia_domain_list) }
  if $appserver_domain_list { validate_hash($appserver_domain_list) }
  if $prcs_domain_list { validate_hash($prcs_domain_list) }

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

if ($io_filebeat::web_logs != undef) {
  contain ::io_filebeat::web_logs
}

