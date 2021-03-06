module RolloutUi
  class Wrapper
    class NoRolloutInstance < StandardError; end

    attr_reader :rollout

    def initialize(rollout = nil)
      @rollout = rollout || RolloutUi.rollout
      raise NoRolloutInstance unless @rollout
    end

    def groups
      # rollout.instance_variable_get("@groups").keys
      ([:all, :admin, :support, :pro, :starter] + rollout.instance_variable_get("@groups").keys).to_set.to_a
    end
    
    def features
      features = @rollout.features
      features ? features.sort : []
    end

    def redis
      rollout.instance_variable_get("@storage")
    end
  end
end
