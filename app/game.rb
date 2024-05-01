require 'app/brick'
require 'app/paddle'

class Game
  def game args
    args.state.paddle_width ||= 120
    args.state.ball_speed ||= 5
    args.state.ball_x_direction ||= -1
    args.state.ball_y_direction ||= -1
    args.state.max_ball_direction ||= Math.sqrt(args.state.ball_x_direction ** 2 + args.state.ball_y_direction ** 2)
    args.state.ball_damage ||= 1
    args.state.bricks_left ||= 1000000000
    args.state.brick_width ||= 50
    args.state.brick_height ||= 20
    args.state.brick_health_multiplier ||= 1
    args.state.paddle ||= Paddle.new(x: 640, y: 100, w: args.state.paddle_width, h: 10)
    args.state.wallet ||= 10
    args.state.interest ||= 0.1
    args.state.level_clear_bonus ||= 5
    args.state.bricks ||= []

    set_quadrant_angles args

    args.state.ball ||= { x: 640, y: 360, w: 10, h: 10, path: 'sprites/circle/orange.png' }

    setup_board args if args.state.refresh_board == true
    end_of_level args if args.state.bricks.empty?

    if args.inputs.keyboard.left && args.state.paddle.x > 4
      args.state.paddle.x -= 10
    elsif args.inputs.keyboard.right && args.state.paddle.x < 1280 - 104
      args.state.paddle.x += 10
    end

    if args.state.ball.intersect_rect? args.state.paddle
      modify_ball_direction args
    end

    if args.state.new_ball_x < 0 || args.state.new_ball_x > 1280 - 10
      args.state.ball_x_direction *= -1
    end

    if args.state.new_ball_y < 0 || args.state.new_ball_y > 720 - 10
      args.state.ball_y_direction *= -1
    end

    brick = args.geometry.find_intersect_rect args.state.ball, args.state.bricks
    if brick
      brick_center = { x: brick.x + (brick.w / 2), y: brick.y + (brick.h / 2) }
      ball_center = { x: args.state.ball.x + (args.state.ball.w / 2), y: args.state.ball.y + (args.state.ball.h / 2) }
      test_angle = brick_center.angle_to ball_center
      target_x = args.state.ball_x_direction.positive? ? 180 : 0
      target_y = args.state.ball_y_direction.positive? ? 270 : 90
      if Geometry.angle_within_range? test_angle, target_x, args.state.vertical_quadrant_angle
        args.state.ball_x_direction *= -1
        args.state.move_ball = false
      end

      if Geometry.angle_within_range? test_angle, target_y, args.state.horizontal_quadrant_angle
        args.state.ball_y_direction *= -1
        args.state.move_ball = false
      end
      args.state.bricks_left -= brick.take_damage(args.state.ball_damage)
      args.state.bricks.delete(brick) if brick.health <= 0
    end

    calculate_new_ball_position args
    move_ball args


    args.outputs.labels << [640, 700, "Bricks left: #{args.state.bricks_left}", 5, 1, 255, 255, 255]
    args.outputs.sprites << args.state.bricks
    args.outputs.solids << args.state.paddle
    args.outputs.sprites << args.state.ball
  end

  def set_quadrant_angles args
    args.state.horizontal_quadrant_angle ||= (
      Math.atan((args.state.brick_width / 2) / (args.state.brick_height / 2)) * 180 / Math::PI
    )

    args.state.vertical_quadrant_angle ||= (90 - args.state.horizontal_quadrant_angle)
  end

  def setup_board args
    10.times do |j|
      20.times do |i|
        break if args.state.bricks.length >= 30
        x = 50 + (i * 60)
        y = 650 - (j * 30)
        next if rand(2) == 0
        args.state.bricks << Brick.new(x: x, y: y, w: args.state.brick_width, h: args.state.brick_height, base_health: (rand(7) + 1), health_multiplier: args.state.brick_health_multiplier)
      end
    end
    args.state.refresh_board = false
  end

  def end_of_level args
    args.state.game_state = !args.state.game_state
    args.state.wallet += args.state.level_clear_bonus
    args.state.wallet += (args.state.wallet * args.state.interest).ceil
    args.state.refresh_board = true
  end

  def move_ball args
    args.state.old_ball_x = args.state.ball.x
    args.state.old_ball_y = args.state.ball.y
    args.state.ball.x = args.state.new_ball_x
    args.state.ball.y = args.state.new_ball_y
  end

  def calculate_new_ball_position args
    args.state.new_ball_x = (args.state.ball.x + (args.state.ball_x_direction * args.state.ball_speed))
    args.state.new_ball_y = (args.state.ball.y + (args.state.ball_y_direction * args.state.ball_speed))
  end

  def modify_ball_direction args
    ball_center_x = args.state.ball.x + (args.state.ball.w / 2)
    paddle_center_x = args.state.paddle.x + (args.state.paddle.w / 2)
    pos_x = (ball_center_x - paddle_center_x) / (args.state.paddle.w / 2)
    args.state.ball_x_direction = args.state.max_ball_direction * pos_x * 0.75
    args.state.ball_y_direction = Math.sqrt(args.state.max_ball_direction ** 2 - args.state.ball_x_direction ** 2)
  end
end
