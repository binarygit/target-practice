#!/usr/bin/ruby

class Fireball
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def render
    args.state.fireballs ||= []
    if args.inputs.keyboard.key_down.z
      args.state.fireballs << { x: (args.state.player.x + args.state.player.w) - 12,
                                y: args.state.player.y + 10,
                                w: 34, 
                                h: 34,
                                path: 'sprites/misc/fireball.png'
      }
    end
    increase_fireball_speed
    kill_offscreen_fireballs

    args.state.fireballs.reject! { _1.dead }
    args.outputs.sprites << args.state.fireballs
  end

  private

  def increase_fireball_speed
    args.state.fireballs.each do |fireball|
      fireball.x += args.state.player.speed + 9
    end
  end

  def kill_offscreen_fireballs
    args.state.fireballs.each do |fireball|
      if fireball.x > args.grid.w
        fireball.dead = true
      end
    end
  end
end
