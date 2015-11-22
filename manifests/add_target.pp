# Define: iscsi::add_target
define iscsi::add_target (
  $target_ip = '',
) {

  exec {
    "iscsi_discovery_${title}":
      command => "/sbin/iscsiadm -m discovery -t sendtargets -p ${target_ip}",
      unless  => '/usr/bin/test -d /var/lib/iscsi/send_targets/*',
      require => Service['iscsid'],
      notify  => Service['iscsi'];
    "iscsi_rescan_${title}":
      command => "/sbin/iscsiadm -m discovery -t sendtargets -p ${target_ip}",
      unless  => "/usr/bin/test \"$(/sbin/iscsiadm -m node| /bin/sort)\" = \"$(/sbin/iscsiadm -m discovery -t sendtargets -p ${target_ip}| /bin/sort)\"",
      require => Service['iscsid'],
      notify  => Service['iscsi'],
  }

}
