class io_filebeat::weblogic (
  $ensure          = $io_filebeat::ensure,
  $pia_domain_list = $io_filebeat::pia_domain_list,
  $fields          = $io_filebeat::fields,
) inherits io_filebeat {

  $log_source = {
    'log_source' => 'weblogic'
  }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    filebeat::input {"${domain_name}-weblogic":
      paths             => [
        "${pia_domain_info['ps_cfg_home_dir']}/webserv/${domain_name}/servers/PIA/logs/PIA_weblogic.log",
      ],
      # doc_type          => 'weblogic_log',
      input_type        => 'log',
      ignore_older      => '24h',
      fields_under_root => true,
      tail_files        => true,
      multiline         => {
        pattern => '^####',
        negate  => true,
        what    => 'previous',
        match   => 'after',
      },
      fields            => merge($log_source, $fields),
    }
  }

}
