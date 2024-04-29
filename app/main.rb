require 'app/game'
require 'app/shop'

def tick args
  @game ||= Game.new
  @shop ||= Shop.new

  # @menu.menu args
  @game.game args


  args.outputs.labels << {
    x: 60.from_right,
    y: 30.from_top,
    text: "#{args.gtk.current_framerate.to_sf}"
  }
end

$gtk.reset