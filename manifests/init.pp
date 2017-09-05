# Fix quirks within Puppet itself on supported platforms
# Does nothing in "puppet agent mode", unless told to.
class quirks(
  $force_run = undef
) {
  if ($force_run or ($::puppet_run_mode == "apply")) {
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
  }  # if ($force_run or $::is_puppet_apply)
}
