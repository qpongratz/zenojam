class Gameover
  def game_lost args
    args.outputs.labels << [640, 500, "Whoops, you dropped your ball.", 5, 1, 255, 255, 255]
    args.outputs.labels << [640, 450, "Fret not. For you have a choice.", 5, 1, 255, 255, 255]

    keep_playing_button ||= { x: 350, y: 325, w: 175, h: 50, path: "sprites/ours/button.png"}
    restart_button ||= { x: 750, y: 325, w: 175, h: 50, path: "sprites/ours/button.png"}

    args.outputs.labels << { x: 375, y: 363, text: "Keep Bricking" }
    args.outputs.labels << { x: 787, y: 363, text: "Begin Anew" }

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
    args.outputs.labels << [640, 500, "You are teh billionaire winner!!1!11!@", 5, 1, 255, 255, 255]

    restart_button ||= { x: 515, y: 325, w: 175, h: 50, path: "sprites/ours/button.png"}
    args.outputs.labels << { x: 550, y: 363, text: "Play Again" }
    args.outputs.sprites << restart_button

    if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? restart_button))
      reset_game args
      args.state.current_scene = :title
    end
  end

  def reset_game args
    args.state.bricks_left = 1000000000
    args.state.wallet = 10
    args.state.ball_speed = 5
    args.state.brick_health_multiplier = 1
    args.state.ball_damage = 1
    args.state.bricks = []
  end
end
