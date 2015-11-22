# Class: iscsi
class iscsi (
  $node_startup                           = 'automatic',
  $node_session_auth_authmethod           = '',
  $node_session_auth_username             = '',
  $node_session_auth_password             = '',
  $node_session_auth_username_in          = '',
  $node_session_auth_password_in          = '',
  $initiatorname                          = '',
){

  package { 'iscsi-initiator-utils':
    ensure => present,
  }

  file { '/etc/iscsi/iscsid.conf':
    ensure  => file,
    mode    => '0600',
    require => Package['iscsi-initiator-utils'],
    content => template('iscsi/rh6.iscsid.conf.erb'),
    notify  => Service['iscsi'],
  }

  if $initiatorname != '' {
    file { '/etc/iscsi/initiatorname.iscsi':
      ensure  => file,
      mode    => '0644',
      require => Package['iscsi-initiator-utils'],
      content => template('iscsi/initiatorname.erb'),
      notify  => Service['iscsi'],
    }
  }

  service {
    'iscsi':
      ensure    => running,
      enable    => true;
    'iscsid':
      ensure    => running,
  }

}
