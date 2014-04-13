define nsq::glue::nsq (
  $version = '0.2.27',
  $topic,
  $channel = 'nsq_to_http',
  $nsqd_tcp_addresses = '',
  $nsqlookupd_http_addresses,
  $daemon = 'nsq_to_nsq'
) {

  include 'nsq'

  $instance_name = "nsqtonsq_${name}"
  $instance_args = get_daemon_args(template('nsq/glue/http/args'))

  file {"/etc/init.d/${instance_name}":
    ensure => file,
    content => template('nsq/init'),
    mode => 755,
    owner => '0',
    group => '0',
    notify => Service[$instance_name],
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
