define nsq::glue::file (
  $version = '0.2.27',
  $host_identifier = '',
  $topic,
  $channel = 'nsq_to_file',
  $output_dir = '/tmp',
  $nsqd_tcp_addresses = '',
  $nsqlookupd_http_addresses,
  $daemon = 'nsq_to_file'
){

  include 'nsq'

  $instance_name = "nsqtofile_${name}"
  $instance_args = "-topic=${topic} -lookupd-http-address=${nsqlookupd_http_addresses}"

  file {"/etc/init.d/${instance_name}":
    ensure => file,
    content => template('nsq/glue/init'),
    mode => 755,
    owner => '0',
    group => '0',
    notify => Service['nsqlookupd'],
  }
  ~>

  exec {"update-rc.d ${instance_name} defaults  && /etc/init.d/${instance_name} start":
    path => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
  }

  service {$instance_name: }

  @monit::entry {$instance_name:
    content => template('nsq/glue/monit'),
    require => Service[$instance_name],
  }

}
