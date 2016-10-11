# Fix quirks within Puppet itself on supported platforms
class quirks {
  $_please_rerun = "   \n\n*** Your system was de-quirkified, please re-run Puppet ***\n\n  "
  exec { "${_please_rerun}":
    command => "/bin/false",
    refreshonly => true
  }

  # For some reason, even basic facts are bogus in Ubuntu Xenial's Puppet 3.8.5
  case ($::operatingsystemmajrelease) {
    /\./: {
      file { ["/etc/facter", "/etc/facter/facts.d/"]:
        ensure => "directory"
      } ->
      file { "/etc/facter/facts.d/operatingsystemmajrelease.txt":
        content => inline_template("operatingsystemmajrelease=<%= @operatingsystemmajrelease.split('.')[0] %>")
      } ~> Exec[$_please_rerun]
    }
  }

  # Work around https://bugs.launchpad.net/ubuntu/+source/puppet/+bug/1457957, #lesigh
  case "${::operatingsystem} ${::operatingsystemrelease}" {
    /^Ubuntu 16/: {
      file { "/usr/lib/ruby/vendor_ruby/puppet/provider/service/upstart.rb":
        ensure => "absent"
      } ~> Exec[$_please_rerun] 
    }
  }

  # Shuts useless red stuff in Ubuntu 16.04's Puppet
  $hiera_conf = "${::settings::confdir}/hiera.yaml"
  exec { "true >> ${hiera_conf}":
    path => $::path,
    creates => $hiera_conf
  }
  # No need to restart for this one
}
