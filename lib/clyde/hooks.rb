
module Clyde
  module Hooks
    def before_hooks
      @before_hooks || []
    end

    def add_before_hook(key, &block)
      @before_hooks = {} if @before_hooks.nil?
      @before_hooks[key] = [] unless @before_hooks.has_key?(key)
      @before_hooks[key] << block
    end

    def unset_all_hooks
      @before_hooks = {}
    end
  end
end
