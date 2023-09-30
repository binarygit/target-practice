#def tick args
#  args.outputs.labels  << [640, 540, 'Hello World!', 5, 1]
#  args.outputs.labels  << [640, 500, 'Docs located at ./docs/docs.html and 100+ samples located under ./samples', 5, 1]
#  args.outputs.labels  << [640, 460, 'Join the Discord server! https://discord.dragonruby.org', 5, 1]
#
#  args.outputs.sprites << { x: 576,
#                            y: 280,
#                            w: 128,
#                            h: 101,
#                            path: 'dragonruby.png',
#                            angle: args.state.tick_count }
#
#  args.outputs.labels  << { x: 640,
#                            y: 60,
#                            text: './mygame/app/main.rb',
#                            size_enum: 5,
#                            alignment_enum: 1 }
#end


#def tick(args)
#  args.state.rotation ||= 0
#  args.state.x ||= 576
#  args.state.y ||= 100
#
#  if args.inputs.mouse.click
#    args.state.x = args.inputs.mouse.click.point.x - 64
#    args.state.y = args.inputs.mouse.click.point.y - 50
#  end
#
#  unless args.gtk.platform? :linux
#  args.outputs.labels  << [580, 400, 'Hello World!']
#  end
#  args.outputs.sprites << [args.state.x,
#                           args.state.y,
#                           128, 
#                           101, 
#                           'dragonruby.png', 
#                           args.state.rotation]
#  args.state.rotation -= 1
#end

require_relative 'player.rb'
require_relative 'fireball.rb'
require_relative 'target.rb'

class Game
  attr_reader :args, :speed

  def initialize(args = nil)
    @args  = args
    @speed = 5
    @player    = Player.new(args)
    @fireballs = Fireball.new(args)
    @targets   = Target.new(args)
  end

  def tick
    args.state.timer ||= 30 * 60
    unless game_over?
      render_timer_and_score
      @player.render
      @fireballs.render
      @targets.render
    else
      unless args.audio[:music].paused
        args.audio[:music].paused = true
        args.outputs.sounds << "sounds/game-over.wav"
      end
      display_game_over_screen
    end
  end

  private

  def game_over?
    args.state.timer < 0
  end

  def display_game_over_screen
    labels = []
    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Game Over!",
      size_enum: 10,
    }
    labels << {
      x: 40,
      y: args.grid.h - 90,
      text: "Score: #{args.state.score}",
      size_enum: 4,
    }
    labels << {
      x: 40,
      y: args.grid.h - 132,
      text: "Fire to restart",
      size_enum: 2,
    }
    args.outputs.labels << labels

    if args.inputs.keyboard.key_down.z ||
        args.inputs.keyboard.key_down.j ||
        args.inputs.controller_one.key_down.a
      $gtk.reset
    end
  end

  def render_timer_and_score
    args.state.score ||= 0

    args.state.timer -= 1
    args.outputs.labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Score: #{args.state.score}",
      size_enum: 4
    }

    args.outputs.labels << {
      x: args.grid.w - 180,
      y: args.grid.h - 40,
      text: "Time left: #{(args.state.timer / 60).round}",
      size_enum: 2
    }
  end
end

def tick(args)
  if args.state.tick_count == 1
    args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
  end
  game ||= Game.new(args)
  game.tick
  args.outputs.debug << {
    x: 40,
    y: args.grid.h - 80,
    text: "Targets: #{args.state.targets.map { [_1[:x], _1[:y]] }}",
  }.label!
  args.outputs.solids << {
    x: 0,
    y: 0,
    w: args.grid.w,
    h: args.grid.h,
    r: 92,
    g: 120,
    b: 230,
  }
  args.outputs.sprites << {
    x: 500,
    y: 500,
    h: 100,
    w: 100,
    path: 'sprites/misc/cloud.png'
  }
end

#$gtk.reset
