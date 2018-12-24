class io_filebeat::gh_activity (
  $ensure          = $io_filebeat::ensure,
  $pia_domain_list = $io_filebeat::pia_domain_list,
  $fields          = $io_filebeat::fields,
  $exclude_lines   = $io_filebeat::exclude_lines,
) inherits io_filebeat {

  # if ($exclude_lines = undef) { $exclude_lines = '[]' }

  $pia_domain_list.each |$domain_name, $pia_domain_info| {
    filebeat::prospector {"${domain_name}-gh-activity":
      paths             => [
        "${pia_domain_info['ps_cfg_home_dir']}/webserv/${domain_name}/servers/PIA/logs/activity.csv*",
      ],
      doc_type          => 'activity_log',
      input_type        => 'log',
      # ignore_older      => '24h',
      fields_under_root => true,
      tail_files        => true,
      fields            => $fields,
      exclude_lines     => $exclude_lines,
    }
  }

}