# We don't want an "upstart" provider for the service type on recent Ubuntu.
class quirks::private::subquirks::no_upstart_in_recent_ubuntu {
  case "${::operatingsystem} ${::operatingsystemrelease}" {
    /^Ubuntu 16/: {
      file { [
        "/usr/lib/ruby/vendor_ruby/puppet/provider/service/upstart.rb",
        "/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/provider/service/upstart.rb"
      ]:
        ensure => "absent"
      }
    }
  }
}
