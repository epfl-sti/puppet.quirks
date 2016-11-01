# pluginsync is automatic only for client-server Puppet runs
# See http://somethingsinistral.net/blog/reading-puppet-pluginsync/
class quirks::pluginsync() {
  $libdir = '/var/lib/puppet'   # TODO: probably wrong on some platform or other
  file { $libdir:
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///plugins',
    owner   => 'puppet',
    group   => 'puppet',
    force   => true,
    backup  => false,
    noop    => false,
    }
    file { "${libdir}/state":
      ensure => directory
    }
}
