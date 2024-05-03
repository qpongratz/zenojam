require 'app/game'
require 'app/shop'
require 'app/title'
require 'app/gameover'

def tick args
  @game ||= Game.new
  @shop ||= Shop.new
  @title ||= Title.new
  @gameover ||= Gameover.new

  args.state.current_scene ||= :title

  args.state.state_button ||= { x: 10, y: 10, w: 100, h: 50, path: "sprites/ours/button.png"}

  args.state.background ||= { x: 0, y: 0, w: 1280, h: 720, path: "sprites/background/dungeon.png" }
  args.outputs.sprites << args.state.background


  case args.state.current_scene
  when :title
    @title.start_game args
  when :game
    @game.game args
  when :shop
    @shop.menu args
  when :gameover
    if args.state.bricks_left <= 0
      @gameover.game_won args
    else
      @gameover.game_lost args
    end
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
