class io_filebeat::appserver (
  $ensure          = $io_filebeat::ensure,
  $appserver_domain_list = $io_filebeat::appserver_domain_list,
  $fields          = $io_filebeat::fields,
  $ps_filedir      = $io_filebeat::ps_filedir,
) inherits io_filebeat {

  $log_source = {
    'log_source' => 'appsrv_log'
  }

  $appserver_domain_list.each |$domain_name, $appserv_domain_info| {

    if ($ps_filedir) {
      $appsrv_logs = "${ps_filedir}/LOGS/APPSRV_*.LOG"
    } else {
      $appsrv_logs = "${appserv_domain_info['ps_cfg_home_dir']}/appserv/${domain_name}/LOGS/APPSRV_*.LOG"
    }

    filebeat::input {"${domain_name}-appsrv":
      paths             => [
        $appsrv_logs,
      ],
      input_type        => 'log',
      ignore_older      => '24h',
      fields_under_root => true,
      tail_files        => true,
      fields            => merge($log_source, $fields),
    }
  }

}
