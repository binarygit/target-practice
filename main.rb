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

    args.outputs.sprites << [args.state.player_x, args.state.player_y, 100, 80, 'sprites/misc/dragon-0.png']
    handle_input
    check_boundary
    print_fireballs
  end

  private

  def print_fireballs
    args.state.fireball ||= []
    if args.inputs.keyboard.key_down.z
      args.state.fireball << [args.state.player_x, args.state.player_y + 40, 'fireball']
    end

    args.outputs.labels << args.state.fireball.each { |fireball| fireball[0] += speed + 2 }
  end

  def check_boundary
    if (args.state.player_y + 100) == args.grid.top
      args.state.player_y -= speed
    end

    if (args.state.player_x + 100) == args.grid.right
      args.state.player_x -= speed
    end

    if (args.state.player_x - 50) == args.grid.left
      args.state.player_x += speed
    end

    if (args.state.player_y - 50) == args.grid.bottom
      args.state.player_y += speed
    end
  end

  def handle_input
    if args.inputs.keyboard.right
      args.state.player_x += speed
    elsif args.inputs.keyboard.left
      args.state.player_x -= speed
    end

    if args.inputs.keyboard.up
      args.state.player_y += speed
    elsif args.inputs.keyboard.down
      args.state.player_y -= speed
    end
  end
end

def tick(args)
  game ||= Game.new(args)
  game.tick
end
