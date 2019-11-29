class io_filebeat::pia_access (
  $ensure          = $io_filebeat::ensure,
  $pia_domain_list = $io_filebeat::pia_domain_list,
  $fields          = $io_filebeat::fields,
  $exclude_lines   = $io_filebeat::exclude_lines,
) inherits io_filebeat {

  $log_source = {
    'log_source' => 'access_log'
  }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    filebeat::input {"${domain_name}-pia-access":
      paths             => [
        "${pia_domain_info['ps_cfg_home_dir']}/webserv/${domain_name}/servers/PIA/logs/PIA_access.log*",

      ],
      # doc_type          => 'access_log',
      input_type        => 'log',
      # ignore_older      => '24h',
      fields_under_root => true,
      tail_files        => true,
      fields            => merge($log_source, $fields),
      exclude_lines     => $exclude_lines,
    }
  }

}
