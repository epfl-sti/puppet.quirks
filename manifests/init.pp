# Fix quirks within Puppet itself on supported platforms
class quirks {
  include quirks::private::defines
  quirks::private::defines::subquirk {
    [
     "squelch_hiera_log_noise",
     "no_upstart_in_recent_ubuntu",
     "broken_operatingsystemmajrelease_xenial"
    ]:
  }
  quirks::private::defines::subquirk_incompatible_module { "puppetlabs-ntp":
    req_3x => "< 5.0.0",
    req_4x => "> 5.0.0"
  }
}
