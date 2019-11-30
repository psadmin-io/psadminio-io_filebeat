class io_filebeat::servlet (
  $ensure          = $io_filebeat::ensure,
  $pia_domain_list = $io_filebeat::pia_domain_list,
  $fields          = $io_filebeat::fields,
) inherits io_filebeat {

  $log_source = {
    'log_source' => 'servlet'
  }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    filebeat::input {"${domain_name}-servlet":
      paths             => [
        "${pia_domain_info['ps_cfg_home_dir']}/webserv/${domain_name}/servers/PIA/logs/PIA_servlets*.log*",
      ],
      input_type        => 'log',
      ignore_older      => '24h',
      fields_under_root => true,
      tail_files        => true,
      multiline         => {
        pattern => '^\t',
        negate  => true,
        what    => 'previous',
        match   => 'after',
      },
      fields            => merge($log_source, $fields),
    }
  }

}
