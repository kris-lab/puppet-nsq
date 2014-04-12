class nsq::server (
  $version = '0.2.27',
  $http_address = '0.0.0.0',
  $http_port    = '4151',
  $tcp_address  = '0.0.0.0',
  $tcp_port     = '4150',
  $nsqlookupd_tcp_addresses = []
) {

  include 'nsq'

  file {'/etc/nsq/nsqd.conf':
    ensure => file,
    content => template('nsq/nsqd/conf'),
    mode => 644,
    owner => 'nsq',
  }

  file {'/etc/init.d/nsqd':
    ensure => file,
    content => template('nsq/nsqd/init'),
    mode => 755,
    owner => '0',
    group => '0',
    notify => Service['nsqd'],
  }
  ~>

  exec {'update-rc.d nsqd defaults  && /etc/init.d/nsqd start':
    path => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
  }

  service {'nsqd': }

  @monit::entry {'nsqd':
    content => template('nsq/nsqd/monit'),
    require => Service['nsqd'],
  }

}
