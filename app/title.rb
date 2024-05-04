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

    args.outputs.sprites << {
      x: 750.from_right,
      y: 178,
      w: 64,
      h: 64,
      path: "sprites/kenny/keyboard/keyboard_space_outline.png"
    }

    args.outputs.labels << {
      x: 680.from_right,
      y: 500.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "To Start"
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

    args.outputs.sprites << {
      x: 143.from_left,
      y: 228.from_top,
      w: 36,
      h: 36,
      path: "sprites/kenny/keyboard/keyboard_arrows_horizontal_outline.png"
    }

    args.outputs.sprites << {
      x: 218.from_left,
      y: 228.from_top,
      w: 32,
      h: 32,
      path: "sprites/kenny/keyboard/keyboard_a_outline.png"
    }

    args.outputs.sprites << {
      x: 298.from_left,
      y: 228.from_top,
      w: 32,
      h: 32,
      path: "sprites/kenny/keyboard/keyboard_d_outline.png"
    }


    args.outputs.labels << {
      x: 100.from_left,
      y: 200.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Use      or     and     keys to move paddle left and right."
    }

    args.outputs.sprites << {
      w: 32,
      h: 32,
      x: 227.from_left,
      y: 277.from_top,
      path: "sprites/kenny/keyboard/keyboard_w_outline.png"
    }

    args.outputs.sprites << {
      w: 36,
      h: 36,
      x: 158.from_left,
      y: 277.from_top,
      path: "sprites/kenny/keyboard/keyboard_arrows_up_outline.png"
    }

    args.outputs.labels << {
      x: 100.from_left,
      y: 250.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Press     or     to launch ball from paddle."
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
