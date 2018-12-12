class io_filebeat::appserv (
  $ensure                = $io_filebeat::ensure,
  $appserver_domain_list = $io_filebeat::appserver_domain_list,
  $fields                = $io_filebeat::fields,
) inherits io_filebeat {

  $appserver_domain_list.each |$domain_name, $appserv_domain_info| {
    filebeat::prospector {"${domain_name}-appserv":
      paths             => [
        "${appserv_domain_info['ps_cfg_home_dir']}/files/LOGS/APPSRV_*.LOG",
      ],
      doc_type          => 'appsrv_log',
      input_type        => 'log',
      # ignore_older      => '24h',
      fields_under_root => true,
      tail_files        => true
      fields            => $fields,
    }
  }

}
