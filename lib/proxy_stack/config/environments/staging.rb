Pancake.logger.info "Loading Staging Environment"

# Set the middleware lables to load
Pancake.stack_labels = [:staging]

Pancake.handle_errors!(true) # uncomment to have the stack handle any errors that occur

class ProxyStack
  # include middleware for the development stack
  # stack(:middleware_name).use(MiddlewareClass)
end

# Add code to hooks.  Default available hooks:
# :before_build_stack, :before_mount_applications, :after_initialize_application, :after_build_stack

# ProxyStack.before_build_stack do
#   # stuff to do
# end


