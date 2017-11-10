class quirks::private::puppet_module_versions() {
  # Declare that a module is incompatible between versions 3.x and 4.x of
  # Puppet.
  #
  # === Parameters:
  #
  # $title: The name of the module, e.g. "puppetlabs-ntp"
  #
  # $req_3x: The version requirement to apply for Puppet 3.x (e.g. "< 5.0.0")
  #
  # $req_4x: The version requirement to apply for Puppet 4.x (e.g. "> 5.0.0")
  #
  # $req_5x: The version requirement to apply for Puppet 5.x (e.g. ">
  # 5.1.0"). If omitted, same as $req_4x
  #
  # === Actions:
  #
  # * Upgrade or downgrade $title as appropriate
  define incompatible_module(
    $req_3x,
    $req_4x,
    $req_5x = undef
  ) {
    $puppet_module_versions = parsejson($::puppet_module_versions_json)
    $_current_version = $puppet_module_versions[$title]
    if (versioncmp($::puppetversion, '6') > 0) {
      fail("Cannot deal with version ${::puppetversion} of Puppet")
    } elsif (versioncmp($::puppetversion, '5') > 0) {
      $_verclass = "5.x"
      $_req = $req_5x ? { undef => $req_4x, default => $req_5x }
    } elsif (versioncmp($::puppetversion, '4') > 0) {
      $_verclass = "4.x"
      $_req = $req_4x
    } elsif (versioncmp($::puppetversion, '3') > 0) {
      $_verclass = "3.x"
      $_req = $req_3x
    } else {
      fail("Cannot deal with version ${::puppetversion} of Puppet (too ancient)")
    }

    if (
      ($_current_version != undef) and
      'up-to-date' != inline_template("<%= Gem::Dependency.new('', @_req).match?('', @_current_version) ? 'up-to-date': 'not up-to-date' %>")
    ) {
      # This is completely heuristic:
      if ($_verclass == "4.x") {
        $_upgrade_downgrade = "upgrade"
      } else {
        $_upgrade_downgrade = "downgrade"
      }

      exec { "${_upgrade_downgrade} ${title} for Puppet ${_verclass}":
        command => $_upgrade_downgrade ? {
          "upgrade" => "puppet module upgrade ${title} --version '${req_4x}'",
          "downgrade" => "puppet module uninstall --force ${title}; puppet module install ${title} --version '${req_3x}'"
        },
        path => $::path
      }
    }
  }
}

