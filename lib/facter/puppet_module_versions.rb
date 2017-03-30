# coding: utf-8

unless [].respond_to? :to_h
  class Array
    def to_h
      Hash[self]
    end
  end
end

Facter.add(:puppet_module_versions) do
  setcode do
   module_list = Facter::Core::Execution.exec('puppet module list')
   module_list.scan(/^.*? (\S+) \(\S*v([^\e]*)/m).to_h
  end
end
