require 'pathname'
Puppet::Type.newtype(:dhparam) do
  desc 'A Diffie Helman parameter file'

  ensurable

  newparam(:path, :namevar => true) do
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newproperty(:size) do
    desc 'Manage the dhparam key size'
    newvalues /\d+/
    defaultto 2048
    validate do |value|
      size = value.to_i
      if size <= 0 || value.to_s != size.to_s
        raise ArgumentError, "Size must be a positive integer: #{value.inspect}"
      end
    end
  end

  newparam(:fastmode) do
    desc 'Enable fast mode'
    defaultto false
    validate do |value|
      if !value.is_a?(TrueClass) && !value.is_a?(FalseClass)
        raise ArgumentError, "Fastmode must be a boolean: #{value.inspect} #{value.class}"
      end
    end
  end
end
