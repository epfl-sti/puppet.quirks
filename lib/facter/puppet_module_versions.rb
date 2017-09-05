# coding: utf-8

unless [].respond_to? :to_h
  class Array
    def to_h
      Hash[self]
    end
  end
end


Facter.add(:puppet_module_versions) do
  module_list_cmd = 'puppet module list'
  if Facter.value(:puppet_run_mode) == 'agent'
      # Presumably, people who care enough about Puppet agent will take care
      # of dependencies themselves
      module_list_cmd += ' 2>/dev/null'
  end
  setcode do
   Facter::Core::Execution.exec(module_list_cmd).scan(/^.*? (\S+) \(\S*v([^\e]*)/m).to_h
  end
end

# And for structured-facts-impaired Puppets:
Facter.add(:puppet_module_versions_json) do
  setcode do
    Facter.value(:puppet_module_versions).to_json
  end
end
