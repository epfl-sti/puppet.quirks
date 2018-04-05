# This is the mantra to create function convert_hiera_yaml_to_v5
# in Puppet v3.x. See ../../functions/convert_hiera_yaml_to_v5.rb
# for Puppet v4+.

$LOAD_PATH.unshift File.expand_path('../../', __dir__)
require "HieraFiver"

module Puppet::Parser::Functions
  newfunction(:convert_hiera_yaml_to_v5, :type => :rvalue, :arity => 1,
              :doc => <<-EOS
Convert parameter from Hiera v3 YAML to Hiera v5.
EOS
             ) do |args|
    HieraFiver.new(args[0]).to_5
  end
end
