class GameOver

  def game_lost args
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

    args.outputs.labels << [640, 500, "Daylight is within your grasp.", 5, 1, 255, 255, 255]
    args.outputs.labels << [640, 450, "Don't give up.", 5, 1, 255, 255, 255]

    keep_playing_button ||= { x: 350, y: 325, w: 175, h: 50, path: "sprites/kenny/controls/line-light/square.png"}
    restart_button ||= { x: 750, y: 325, w: 175, h: 50, path: "sprites/kenny/controls/line-light/square.png"}

    args.outputs.labels << { x: 375, y: 363, text: "Keep Bricking", r: 255, g: 255, b: 255}
    args.outputs.labels << { x: 787, y: 363, text: "Begin Anew", r: 255, g: 255, b: 255}

    if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? keep_playing_button))
      args.state.current_scene = :game
    end

    if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? restart_button))
      reset_game args
      args.state.current_scene = :title
    end

    args.outputs.sprites << keep_playing_button
    args.outputs.sprites << restart_button
  end

  def game_won args
    args.outputs.labels << [600, 200, "Congratulations!", 5, 1, 255, 255, 255]
    args.outputs.labels << [600, 160, "You are able to see the night sky once again.", 5, 1, 255, 255, 255]

    args.state.background = { x: 0, y: 0, w: 1280, h: 720, path: "sprites/background/sky.png" }
    restart_button ||= { x: 515, y: 50, w: 175, h: 50, path: "sprites/kenny/controls/line-light/square.png"}
    args.outputs.labels << { x: 575, y: 85, text: "Quit", r: 255, g: 255, b: 255}
    args.outputs.sprites << restart_button

    if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? restart_button))
      args.gtk.request_quit
    end
  end

  def reset_game args
    args.state.bricks_left = 1000000000
    args.state.wallet = 10
    args.state.ball_speed = 5
    args.state.max_brick_health = 2
    args.state.brick_health_multiplier = 1
    args.state.ball_damage = 1
    args.state.bricks = []
    args.state.explosion = false
    args.state.gold_brick_chance = 10
    args.state.paddle_width = 120
    args.state.paddle_speed = 10
  end
end
