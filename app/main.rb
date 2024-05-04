require 'app/game'
require 'app/shop'
require 'app/title'
require 'app/game_over'

def tick args
  @game ||= Game.new
  @shop ||= Shop.new
  @title ||= Title.new
  @game_over ||= GameOver.new

  args.state.current_scene ||= :title

  args.state.state_button ||= { x: 10, y: 10, w: 100, h: 50, path: "sprites/controls/line-light/square.png"}

  args.state.background ||= { x: 0, y: 0, w: 1280, h: 720, path: "sprites/background/dungeon.png" }
  args.outputs.sprites << args.state.background


  case args.state.current_scene
  when :title
    @title.start_game args
  when :game
    @game.game args
  when :shop
    @shop.menu args
  when :game_over
    if args.state.bricks_left <= 0
      @game_over.game_won args
    else
      @game_over.game_lost args
    end
  when :paused
    args.outputs.labels << [640, 360, "Paused", 5, 1, 255, 255, 255]
    args.outputs.sprites << {
      x: 50,
      y: 120,
      w: 1180,
      h: 520,
      r: 0,
      g: 0,
      b: 0,
      a: 120,
      path: "sprites/ours/black.png"
    }
  end


  if args.inputs.keyboard.key_down.escape
    args.state.current_scene == :game ? args.state.current_scene = :paused : args.state.current_scene = :game
  end


  args.outputs.labels << {
    x: 60.from_right,
    y: 75.from_top,
    r: 255,
    g: 255,
    b: 255,
    text: "#{args.gtk.current_framerate.to_sf} "
  }


  args.state.mute.border ||= { x: 50.from_right, y: 50.from_top, w: 100, h: 50, r: 255, g: 255, b: 255, a: 0 }

  if args.state.tick_count == 1
    args.audio[:music] = {
      input: 'sounds/ours/title.mp3',
      gain: 0.75,
      looping: true,
      paused: false
    }
    elsif args.state.tick_count > 2

    mute = {
      x: 50.from_right,
      y: 50.from_top,
      h: 32,
      w: 32,
      path: args.audio[:music].paused == true ? 'sprites/controls/line-light/mute.png' : 'sprites/controls/line-light/unmute.png'
    }

    args.outputs.sprites << mute
    args.outputs.borders << args.state.mute.border

    if (args.inputs.mouse.click) &&
      (args.inputs.mouse.point.inside_rect? args.state.mute.border)
      args.audio[:music].paused == true ? args.audio[:music].paused = false : args.audio[:music].paused = true
    end
  end
end

$gtk.reset
