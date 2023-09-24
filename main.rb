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

class Game
  attr_reader :args, :speed

  def initialize(args = nil)
    @args  = args
    @speed = 5
  end

  def tick
    args.state.player_x ||= 120
    args.state.player_y ||= 280
    args.state.player   ||= {
      x: 120,
      y: 280,
      w: 100,
      h: 80,
      speed: 2,
      path: 'sprites/misc/dragon-0.png'
    }

    args.outputs.sprites << args.state.player
    handle_input
    check_boundary
    print_fireballs
    print_targets
  end

  private

  def print_targets
    args.state.targets ||= [
      spawn_target(800, 120),
      spawn_target(920, 600),
      spawn_target(1020, 320),
    ]

    args.outputs.sprites << args.state.targets
  end

  def spawn_target(x, y)
    {
      x: x,
      y: y,
      w: 64,
      h: 64,
      path: 'sprites/misc/target.png',
    }
  end

  def print_fireballs
    args.state.fireballs ||= []
    if args.inputs.keyboard.key_down.z
      args.state.fireballs << { x: (args.state.player.x + args.state.player.w) - 12,
                                y: args.state.player.y + 10,
                                w: 34, 
                                h: 34,
                                path: 'sprites/misc/fireball.png'
      }
    end

    args.state.fireballs.each do |fireball|
      fireball.x += args.state.player.speed + 2
    end

    args.outputs.sprites << args.state.fireballs
  end

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

def tick(args)
  game ||= Game.new(args)
  game.tick
end
