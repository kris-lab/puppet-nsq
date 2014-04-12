class nsq::admin (
  $version = '0.2.27',
  $address = '0.0.0.0',
  $port    = '4171',
  $nsqd_http_addresses = [],
  $nsqlookupd_http_addresses = []
) {

  include 'nsq'

  if !count($nsqd_http_addresses) and !count($nsqlookupd_http_addresses) {
    fails('nsqd_http_addresses or lookupd_http_addresses must be provided!')
  }

  file {'/etc/nsq/nsqadmin.conf':
    ensure => file,
    content => template('nsq/nsqadmin/conf'),
    mode => 644,
    owner => 'nsq',
  }

  file {'/etc/init.d/nsqadmin':
    ensure => file,
    content => template('nsq/nsqadmin/init'),
    mode => 755,
    owner => '0',
    group => '0',
    notify => Service['nsqadmin'],
  }
  ~>

  exec {'update-rc.d nsqadmin defaults  && /etc/init.d/nsqadmin start':
    path => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
  }

  service {'nsqadmin': }

  @monit::entry {'nsqadmin':
    content => template('nsq/nsqadmin/monit'),
    require => Service['nsqadmin'],
  }

}
