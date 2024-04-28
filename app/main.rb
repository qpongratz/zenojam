require 'app/brick'
def tick args
  args.state.bricks_left ||= 1000000000
  args.state.paddle ||= { x: 100, y: 100, w: 120, h: 10, r: 0, g: 0, b: 0 }

  args.state.ball ||= { x: 640, y: 360, w: 10, h: 10, path: 'sprites/circle/orange.png' }

  args.state.bricks ||= []
  if args.state.tick_count == 0 || args.state.bricks.empty?
    20.times do |i|
      x = 50 + (i * 60)
      args.state.bricks << Brick.new(x: x, y: 600, w: 50, h: 20 )
    end
  end

  args.state.ball_speed ||= 5
  args.state.ball_x_direction ||= -1
  args.state.ball_y_direction ||= -1

  if args.inputs.keyboard.left && args.state.paddle.x > 4
    args.state.paddle.x -= 5
  elsif args.inputs.keyboard.right && args.state.paddle.x < 1280 - 104
    args.state.paddle.x += 5
  end


  if args.state.ball.intersect_rect? args.state.paddle
    args.state.ball_y_direction *= -1
    calculate_new_ball_position args
  end

  if args.state.new_ball_x < 0 || args.state.new_ball_x > 1280 - 20
    args.state.ball_x_direction *= -1
  end

  if args.state.new_ball_y < 0 || args.state.new_ball_y > 720 - 20
    args.state.ball_y_direction *= -1
  end

  args.state.bricks.each_with_index do |brick, index|
    next unless args.state.ball.intersect_rect? brick
    args.state.bricks.delete_at index
    args.state.bricks_left -= 1
    args.state.ball_y_direction *= -1
  end

  calculate_new_ball_position args
  move_ball args


  args.outputs.labels << [640, 700, "Bricks left: #{args.state.bricks_left}", 5, 1, 255, 255, 255]
  args.outputs.sprites << args.state.bricks
  args.outputs.solids << args.state.paddle
  args.outputs.sprites << args.state.ball
end

def move_ball args
  args.state.old_ball_x = args.state.ball.x
  args.state.old_ball_y = args.state.ball.y
  args.state.ball.x = args.state.new_ball_x
  args.state.ball.y = args.state.new_ball_y
end

def reset_ball args
  args.state.ball.x = args.state.old_ball_x
  args.state.ball.y = args.state.old_ball_y
end

def calculate_new_ball_position args
  args.state.new_ball_x = (args.state.ball.x + (args.state.ball_x_direction * args.state.ball_speed))
  args.state.new_ball_y = (args.state.ball.y + (args.state.ball_y_direction * args.state.ball_speed))
end

$gtk.reset