#!/usr/bin/ruby

class Target
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def render
    args.state.targets ||= [
      spawn_target,
      spawn_target,
      spawn_target,
    ]
    args.state.targets.reject! { _1.dead }
    args.outputs.sprites << args.state.targets
    target_hit?
  end

  private

  def target_hit?
    args.state.targets.each do |t|
      args.state.fireballs.each do |f| 
        if t.intersect_rect? f
          args.outputs.sounds << "sounds/target.wav"
          f.dead = true
          t.dead = true 
          args.state.targets << spawn_target
          args.state.score += 1
        end
      end
    end
  end

  def spawn_target
    size = 64
    {
      x: rand(args.grid.w * 0.4)        + args.grid.w * 0.6,
      y: rand(args.grid.h - size * 2)   + size,
      w: 64,
      h: 64,
      path: 'sprites/misc/target.png',
    }
  end
end
