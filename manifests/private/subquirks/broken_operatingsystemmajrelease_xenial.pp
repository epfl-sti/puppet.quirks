# Exactly what it says on the tin.
class quirks::private::subquirks::broken_operatingsystemmajrelease_xenial {
  case ($::operatingsystemmajrelease) {
    /\./: {
      file { ["/etc/facter", "/etc/facter/facts.d/"]:
        ensure => "directory"
      } ->
      file { "/etc/facter/facts.d/operatingsystemmajrelease.txt":
        content => inline_template("operatingsystemmajrelease=<%= @operatingsystemmajrelease.split('.')[0] %>")
      }
    }
  }
}
