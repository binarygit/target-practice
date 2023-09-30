#!/usr/bin/ruby

class Player
  attr_reader :args, :speed

  def initialize(args)
    @args  = args
    @speed = 5
  end

  def render
    args.state.player   ||= {
      x: 120,
      y: 280,
      w: 100,
      h: 80,
      speed: 2,
    }
    player_sprite_index = 0.frame_index(count: 6, hold_for: 8, repeat: true)
    args.state.player.path = "sprites/misc/dragon-#{player_sprite_index}.png"
    args.outputs.sprites << args.state.player
    handle_input
    check_boundary
  end

  private

  def check_boundary
    if (args.state.player.y + 100) == args.grid.top
      args.state.player.y -= speed
    end

    if (args.state.player.x + 100) == args.grid.right
      args.state.player.x -= speed
    end

    if (args.state.player.x - 50) == args.grid.left
      args.state.player.x += speed
    end

    if (args.state.player.y - 50) == args.grid.bottom
      args.state.player.y += speed
    end
  end

  def handle_input
    if args.inputs.keyboard.right
      args.state.player.x += speed
    elsif args.inputs.keyboard.left
      args.state.player.x -= speed
    end

    if args.inputs.keyboard.up
      args.state.player.y += speed
    elsif args.inputs.keyboard.down
      args.state.player.y -= speed
    end
  end
end
