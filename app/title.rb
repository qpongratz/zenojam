class Title
  def start_game args
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

    args.outputs.labels << {
      x: 140.from_left,
      y: 197,
      r: 255,
      g: 255,
      b: 255,
      text: "- Pause"
    }

    args.outputs.sprites << {
      x: 100.from_left,
      y: 170,
      w: 32,
      h: 32,
      path: "sprites/kenny/keyboard/keyboard_escape_outline.png"
    }

    args.outputs.labels << {
      x: 140.from_left,
      y: 157,
      r: 255,
      g: 255,
      b: 255,
      text: "- Mute"
    }

    args.outputs.sprites << {
      x: 100.from_left,
      y: 130,
      w: 32,
      h: 32,
      path: "sprites/kenny/keyboard/keyboard_m_outline.png"
    }

    args.outputs.labels << {
      x: 750.from_right,
      y: 500.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Space To Start"
    }
    args.outputs.labels << {
      x: 500.from_left,
      y: 100.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Billion Brick Breaker",
      size_enum: 5
    }
    args.outputs.labels << {
      x: 100.from_left,
      y: 150.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "You have been imprisoned in a dungeon and you must break 1 billion bricks to escape."
    }

    args.outputs.labels << {
      x: 100.from_left,
      y: 200.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Use Left and Right or A and D keys to move paddle left and right."
    }

    args.outputs.labels << {
      x: 100.from_left,
      y: 250.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Press Up or W to launch ball from paddle."
    }

    args.outputs.labels << {
      x: 100.from_left,
      y: 300.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "When you have broken most bricks for a level you can go to a shop to buy power-ups."
    }

    args.outputs.labels << {
      x: 100.from_left,
      y: 350.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Don't fall behind. Each level you progress the bricks become ten times stronger."
    }

    args.outputs.labels << {
      x: 100.from_left,
      y: 400.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Good Luck."
    }

    if args.inputs.mouse.click || args.inputs.keyboard.key_down.space || args.inputs.keyboard.key_down.up || args.inputs.keyboard.key_down.w || args.inputs.keyboard.key_down.escape
      args.state.current_scene = :game
      args.state.refresh_board = true
    end
  end
end
