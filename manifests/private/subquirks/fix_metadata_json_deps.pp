# Dependencies mentioned in metadata.json should have e.g.
# "name":"puppetlabs/stdlib" not "name":"puppetlabs-stdlib",
# or "puppet module list" will whine.
# 
class quirks::private::subquirks::fix_metadata_json_deps {
  $_modulepath = $::settings::basemodulepath
  exec { "correct all dependencies in metadata.json:":
    path => $::path,
    command => "false",
    unless => inline_template("find <%= @_modulepath.gsub(':', ' ') %> \
         -name metadata.json -print0 | xargs -0 \
        sed -i 's|puppetlabs-stdlib|puppetlabs/stdlib|' ")
  }
}
