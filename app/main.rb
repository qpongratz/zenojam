require 'app/game'
require 'app/shop'
require 'app/title'
require 'app/gameover'

def tick args
  @game ||= Game.new
  @shop ||= Shop.new
  @title ||= Title.new
  @gameover ||= Gameover.new

  args.state.current_scene = :title if args.state.current_scene.nil?
  @title.start_game args if args.state.current_scene == :title

  state_button ||= { x: 10, y: 10, w: 100, h: 50, path: "sprites/ours/button.png"}

  args.outputs.labels << { x: 25, y: 45, text: "To #{args.state.current_scene == :game ? "Shop" : "Game" }" }

  if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? state_button))
    args.state.current_scene = args.state.current_scene == :shop ? :game : :shop
  end

  args.state.background ||= { x: 0, y: 0, w: 1280, h: 720, path: "sprites/background/dungeon.png" }
  args.outputs.sprites << args.state.background
  args.outputs.sprites << state_button


  @shop.menu args if args.state.current_scene == :shop
  @game.game args if args.state.current_scene == :game
  @gameover.game_won args if args.state.current_scene == :gameover && args.state.bricks_left <= 0
  @gameover.game_lost args if args.state.current_scene == :gameover && args.state.bricks_left > 0

  if args.state.current_scene == :game || args.state.current_scene == :shop
    args.outputs.labels << [50, 700, "$#{args.state.wallet}", 5, 1, 0, 255, 150]
   end

  args.outputs.labels << {
    x: 60.from_right,
    y: 30.from_top,
    r: 255,
    g: 255,
    b: 255,
    text: "#{args.gtk.current_framerate.to_sf} "
  }
end

$gtk.reset
