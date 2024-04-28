def tick args
  args.state.paddle ||= { x: 100, y: 100, w: 150, h: 30, r: 0, g: 0, b: 0 }

  args.state.ball ||= { x: 640, y: 360, w: 10, h: 10, r: 0, g: 0, b: 255 }

  args.state.ball_speed ||= 5
  args.state.ball_x_direction ||= -1
  args.state.ball_y_direction ||= -1



  # move ball in a direction
  # check if ball is colliding with paddle or edges
  # redirect ball if that is happening

  if args.inputs.keyboard.left && args.state.paddle.x > 4
    args.state.paddle.x -= 5
  elsif args.inputs.keyboard.right && args.state.paddle.x < 1280 - 104
    args.state.paddle.x += 5
  end

  calculate_new_ball_position args

  if args.state.ball.intersect_rect? args.state.paddle
    args.state.ball_y_direction *= -1
    calculate_new_ball_position args
  elsif args.state.new_ball_x < 0 || args.state.new_ball_x > 1280 - 20
    args.state.ball_x_direction *= -1
    calculate_new_ball_position args
  elsif args.state.new_ball_y < 0 || args.state.new_ball_y > 720 - 20
    args.state.ball_y_direction *= -1
    calculate_new_ball_position args
  end

  args.state.ball.x = args.state.new_ball_x
  args.state.ball.y = args.state.new_ball_y


  args.outputs.solids << args.state.paddle
  args.outputs.solids << args.state.ball
end

def calculate_new_ball_position args
  args.state.new_ball_x = (args.state.ball.x + (args.state.ball_x_direction * args.state.ball_speed))
  args.state.new_ball_y = (args.state.ball.y + (args.state.ball_y_direction * args.state.ball_speed))

end

$gtk.reset