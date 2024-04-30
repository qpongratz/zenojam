require 'app/game'
require 'app/shop'

def tick args
  @game ||= Game.new
  @shop ||= Shop.new
  args.state.game_state = true if args.state.game_state.nil?

  state_button ||= { x: 10, y: 10, w: 100, h: 50 }

  args.outputs.labels << { x: 10, y: 30, text: "To #{args.state.game_state ? "Shop" : "Game"}" }
  args.outputs.borders << state_button

  if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? state_button))
    args.state.game_state = !args.state.game_state
  end

  @shop.menu args unless args.state.game_state
  @game.game args if args.state.game_state


  args.outputs.labels << {
    x: 60.from_right,
    y: 30.from_top,
    text: "#{args.gtk.current_framerate.to_sf}"
  }
end

$gtk.reset
