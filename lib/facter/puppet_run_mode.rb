require 'logger'

$logger = Logger.new(STDERR)

cmdline = File.read("/proc/self/cmdline").split("\000").drop_while do |word|
  ! ["apply", "agent"].include? word
end

Facter.add('puppet_run_mode') do
  setcode do
    cmdline[0]
  end
end

Facter.add('is_puppet_apply') do
  setcode do
    cmdline[0] == 'apply'
  end
end
