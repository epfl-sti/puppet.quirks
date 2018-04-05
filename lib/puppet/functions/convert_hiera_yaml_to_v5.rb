# This is the mantra to create function convert_hiera_yaml_to_v5
# in Puppet v4+. See ../parser/functions/convert_hiera_yaml_to_v5.rb
# for Puppet v3.

$LOAD_PATH.unshift File.expand_path('../', __dir__)
require "HieraFiver"

Puppet::Functions.create_function(:convert_hiera_yaml_to_v5) do
  dispatch :convert do
    param 'String', :version_3_yaml
  end

  def convert(version_3_yaml)
    HieraFiver.new(version_3_yaml).to_5
  end
end
