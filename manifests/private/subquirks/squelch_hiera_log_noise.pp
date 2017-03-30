# Ensure that hiera.yaml exists, lest we get some scary red lines.
class quirks::private::subquirks::squelch_hiera_log_noise {
  $hiera_conf = "${::settings::confdir}/hiera.yaml"
  exec { "true >> ${hiera_conf}":
    path => $::path,
    creates => $hiera_conf
  }
}
