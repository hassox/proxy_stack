require 'pancake'
class ProxyStack < Pancake::Stacks::Short
  add_root(__FILE__, "proxy_stack")

  # Hook to use before we mount any applications
  # before_mount_applications do
  # end

  initialize_stack
end

require ::File.join(Pancake.get_root(__FILE__, "proxy_stack"), "proxy_stack")
