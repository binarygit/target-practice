#!/usr/bin/ruby

class Target
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def render
    args.state.targets ||= [
      spawn_target(800, 120),
      spawn_target(920, 600),
      spawn_target(1020, 320),
    ]
    args.state.targets.reject! { _1.dead }
    args.outputs.sprites << args.state.targets
  end

  private

  def spawn_target(x, y)
    {
      x: x,
      y: y,
      w: 64,
      h: 64,
      path: 'sprites/misc/target.png',
    }
  end
end
