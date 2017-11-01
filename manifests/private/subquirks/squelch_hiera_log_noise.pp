# Ensure that hiera.yaml exists, and if it does, that it uses the proper version
class quirks::private::subquirks::squelch_hiera_log_noise {
  $hiera_yaml = "${::settings::confdir}/hiera.yaml"

  $previous_version = inline_template('<%= File.read(@hiera_yaml) rescue "" %>')
  if ($previous_version == "") {
    file { $hiera_yaml:
      ensure => "present",
      content => ""
    }
  } elsif ($previous_version !~ /version: 5/) {
    file { $hiera_yaml:
      ensure => "present",
      content => ::quirks::convert_hiera_yaml($previous_version)
    }
    file { "$hiera_yaml.OLD":
      ensure => "present",
      content => $previous_version
    }
  }
}
