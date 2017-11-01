require 'yaml'

class HieraFiver
  """Convert hiera.yml version 3 to version 5

  Adapted from https://github.com/WhatsARanjit/puppet-hi5er/blob/master/lib/hi5er.rb

  Authoritative documentation is at
  https://puppet.com/docs/puppet/5.3/hiera_migrate_v3_yaml.html
  """

  def initialize(yaml_text)
    @backends_data_hash  = ['yaml', 'json', 'hocon']
    @backends_lookup_key = ['eyaml']
    @backends_data_dig   = []
  
    @config5 = { 'version' => 5, 'hierarchy' => [], }
    @config3 = YAML.load(yaml_text)
    parse_config3
  end

  # Use accessors in order to specify more backends under each category
  attr_accessor :backends_data_hash, :backends_lookup_key, :backends_data_dig

  def to_5
    fix_quotes(@config5.to_yaml)
  end

  private
  
  def parse_config3
    @config3[:backends].each do |backend|
      if @backends_data_hash.include?(backend)
        lookupk = 'data_hash'
        lookupv = "#{backend}_data"
      elsif @backends_lookup_key.include?(backend)
        lookupk = 'lookup_key'
        lookupv = "#{backend}_lookup_key"
      elsif @backends_data_dig.include?(backend)
        lookupk = 'data_dig'
        lookupv = "#{backend}_data_dig"
      else
        lookupk = 'hiera3_backend'
        lookupv = backend
      end
      level = {
        'name'    => "#{backend.capitalize} backend",
        lookupk   => lookupv,
      }
      options          = has_options?(backend) ? options_hash(backend) : false
      # Use eyaml's configured extension if exists
      extension        = options.has_key?('extension') ? options['extension'] : 'eyaml' if options
      extension      ||= backend
      # Eyaml extensions are handled in path now
      #options.delete('extension') if backend == 'eyaml'
      level['paths']   = @config3[:hierarchy].map { |p| interpolate(p, extension) } if @config3[:hierarchy]
      level['datadir'] = @config3[backend.to_sym][:datadir] if @config3[backend.to_sym][:datadir]
      level['options'] = options if options
      @config5['hierarchy'] << level
    end
  end

  def options_hash(backend)
    options = Hash.new
    @config3[backend.to_sym].each do |k,v|
      options[k.to_s] = no_symbols(v) unless k == :datadir
    end
    options
  end

  def no_symbols(input)
    if input.is_a?(Hash)
      Hash[input.map{ |k, v| [k.to_s, v] }] if input.is_a?(Hash)
    else
      input
    end
  end

  def has_options?(backend)
    @config3[backend.to_sym].select { |k,v| k != :datadir }.length > 0
  end

  def interpolate(path, extension)
    if path.include?('%')
      "'#{path}.#{extension}'"
    else
      "\"#{path}.#{extension}\""
    end
  end

  def fix_quotes(input)
    # YAML does quotes automatically, so unable to easily
    # leave a double-quoted interpolation string behind.
    fixed = input.gsub(/^([\s\t]+)\- "'/, '\1- "')
    fixed = fixed.gsub(/^([\s\t]+)\- '"/, '\1- \'')
    fixed = fixed.gsub(/'"$/, '"')
    fixed = fixed.gsub(/"'$/, '\'')
    fixed
  end
end

Puppet::Functions.create_function(:'quirks::convert_hiera_yaml') do
  dispatch :convert do
    param 'String', :version_3_yaml
  end

  def convert(version_3_yaml)
    HieraFiver.new(version_3_yaml).to_5
  end
end

