require 'app/game'
require 'app/shop'

def tick args
  @game ||= Game.new
  @shop ||= Shop.new
  args.state.game_state = true if args.state.tick_count == 0
  args.state.refresh_board = true if args.state.tick_count == 0

  state_button ||= { x: 10, y: 10, w: 100, h: 50, path: "sprites/ours/button.png"}

  args.outputs.labels << { x: 25, y: 45, text: "To #{args.state.game_state ? "Shop" : "Game"}" }

  if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? state_button))
    args.state.game_state = !args.state.game_state
  end
  args.state.background ||= { x: 0, y: 0, w: 1280, h: 720, path: "sprites/background/dungeon.png" }
  args.outputs.sprites << args.state.background
  args.outputs.sprites << state_button


  @shop.menu args unless args.state.game_state
  @game.game args if args.state.game_state

  args.outputs.labels << [50, 700, "$#{args.state.wallet}", 5, 1, 0, 255, 150]

  args.outputs.labels << {
    x: 60.from_right,
    y: 30.from_top,
    r: 255,
    g: 255,
    b: 255,
    text: "#{args.gtk.current_framerate.to_sf}"
  }
end

$gtk.reset
