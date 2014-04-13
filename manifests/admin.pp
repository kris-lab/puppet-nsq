class nsq::admin (
  $version      = '0.2.27',
  $http_address = '0.0.0.0',
  $http_port    = '4171',
  $nsqd_http_addresses = [],
  $nsqlookupd_http_addresses = [],
  $daemon       = 'nsqadmin'
) {

  include 'nsq'

  $instance_name = $daemon
  $instance_args = "-config /etc/nsq/${daemon}.conf"

  if !count($nsqd_http_addresses) and !count($nsqlookupd_http_addresses) {
    fails('nsqd_http_addresses or lookupd_http_addresses must be provided!')
  }

  file {"/etc/nsq/${daemon}.conf":
    ensure => file,
    content => template("nsq/${daemon}/conf"),
    mode => 644,
    owner => 'nsq',
  }

  file {"/etc/init.d/${daemon}":
    ensure => file,
    content => template('nsq/init'),
    mode => 755,
    owner => '0',
    group => '0',
    notify => Service[$daemon],
  }
  ~>

  exec {"update-rc.d ${daemon} defaults  && /etc/init.d/${daemon} start":
    path => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
  }

  service {$daemon: }

  @monit::entry {$daemon:
    content => template('nsq/monit'),
    require => Service[$daemon],
  }

}
