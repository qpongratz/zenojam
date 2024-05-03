class Title
  def start_game args
    args.outputs.labels << [625, 500, "Click mouse to start", 5, 1, 0, 255, 150]

    if args.inputs.mouse.click
      args.state.current_scene = :game
      args.state.refresh_board = true
    end
  end
end
