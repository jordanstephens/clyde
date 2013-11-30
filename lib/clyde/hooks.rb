require "clyde/hooks/hook"

module Clyde
  module Hooks
    def add_before_hook(key, &block)
      @before_hooks ||= []
      @before_hooks << Hook.new(key, &block)
    end

    def before_hooks
      @before_hooks || []
    end

    def before_each_hooks
      before_hooks.select { |hook| hook.key == :each }
    end

    def before_matched_hooks
      before_hooks.select { |hook| hook.key.is_a?(Regexp) }
    end

    def unset_all_hooks
      @before_hooks = []
    end
  end
end

