class Title
  def start_game args
    p "I am running"

    args.outputs.labels << {
      x: 800.from_right,
      y: 300.from_top,
      r: 255,
      g: 255,
      b: 255,
      text: "Click To Start"
    }
    if args.inputs.mouse.click
      args.state.current_scene = :game
      args.state.refresh_board = true
    end
  end
end
