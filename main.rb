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
    args.state.score ||= 0
    args.outputs.labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Score: #{args.state.score}",
      size_enum: 4
    }

    @player.render
    @fireballs.render
    @targets.render
  end
end

def tick(args)
  game ||= Game.new(args)
  game.tick
  args.outputs.debug << {
    x: 40,
    y: args.grid.h - 80,
    text: "Targets: #{args.state.targets.map { [_1[:x], _1[:y]] }}",
  }.label!
end

$gtk.reset
