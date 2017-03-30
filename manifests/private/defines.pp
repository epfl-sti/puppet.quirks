# Defines used by the top-level manifest
class quirks::private::defines {
  # In order to mend the Puppet configuration itself as we progress,
  # all tasks are applied in a "puppet apply" subprocess.
  #
  # === Parameters:
  #
  # $puppet_mantra::  The snippet to pass to a sub-"puppet apply -e";
  #                   defaults to $title.
  #                   *Attention*: it MUST NOT use single quotes.
  define run_puppet_apply_to_fixpoint(
      $puppet_mantra = undef
    ) {
    if ($puppet_mantra == undef) {
      $exec_descr = "run puppet apply -e ${title} to fixpoint"
      $_actual_puppet_mantra = $title
    } else {
      $exec_descr = $title
      $_actual_puppet_mantra = $puppet_mantra
    }
    $log_file = inline_template('<%= require("tempfile")
       Tempfile.new("epflsti-quirks-").path %>')
    exec { $exec_descr:
      command => "cat ${log_file} >&2; false",
      path => $::path,
      unless => inline_template('true ; set -x
      for try in $(seq 1 5); do
         puppet apply -e "<%= @_actual_puppet_mantra %>"
         case $? in
           2) continue ;;
           0) rm -rf <%= @log_file %>; exit 0 ;;
           *)
             errorcode=$?
             (set +x; tput bold; tput setaf 4; echo >&2 "======================================= sub-Puppet logs (more legible) were kept in <%= @log_file %> ======================================="; tput sgr0)
             exit $errorcode ;;
         esac
      done > <%= @log_file %> 2>&1
      ')
    }
  }
  define subquirk() {
    ::quirks::private::defines::run_puppet_apply_to_fixpoint {
      "class { 'quirks::private::subquirks::${title}': }":
    }
  }

  define subquirk_incompatible_module($req_3x, $req_4x) {
    $puppet_mantra = inline_template(
      "include quirks::private::puppet_module_versions

      ::quirks::private::puppet_module_versions::incompatible_module {
        '<%= @title %>':
          req_3x => '<%= @req_3x %>',
          req_4x => '<%= @req_4x %>'
      }"
    )
    ::quirks::private::defines::run_puppet_apply_to_fixpoint {
      "incompatible_module ${title}":
        puppet_mantra => $puppet_mantra
    }
  }
}
