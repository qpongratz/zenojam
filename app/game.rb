require 'app/brick'
require 'app/paddle'
require 'app/power_up'
require 'app/explosion'

class Game
  def game args
    args.state.max_brick_health ||= 1
    args.state.explosions ||= []
    args.state.power_ups ||= []
    args.state.power_up_speed ||= 8
    args.state.paddle_width ||= 120
    args.state.paddle_speed ||= 10
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
    args.state.gold_brick_chance ||= 10
    args.state.level_clear_bonus ||= 5
    args.state.bricks ||= []
    args.state.play_space_width ||= 800
    args.state.play_space_height ||= 600
    args.state.play_x ||= 150
    args.state.play_y ||= 100
    args.state.play_space_max_x ||= args.state.play_x + args.state.play_space_width
    args.state.play_space_max_y ||= args.state.play_y + args.state.play_space_height
    args.state.play_border = { x: args.state.play_x, y: args.state.play_y, w: args.state.play_space_width, h: args.state.play_space_height, r: 255, g: 255, b: 255 }
    set_quadrant_angles args

    args.state.explosions.each(&:advance)
    args.state.explosions.reject! { |explosion| explosion.dead?}
    args.state.ball ||= { x: 640, y: 360, w: 10, h: 10, path: 'sprites/ours/ball.png' }

    setup_board args if args.state.refresh_board == true
    end_of_level args if args.state.bricks.empty?

    if args.inputs.up && args.state.ball_launched == false
      launch_ball args
      args.state.ball_launched = true
    end

    if args.state.ball.y < args.state.play_y
      args.state.current_scene = :gameover
      args.state.refresh_board = true
      args.state.bricks = []
    end

    if args.inputs.left && args.state.paddle.x > args.state.play_x
      args.state.paddle.x -= args.state.paddle_speed
      args.state.ball.x -= args.state.paddle_speed if args.state.ball_launched == false
    elsif args.inputs.right && args.state.paddle.x < args.state.play_space_max_x - 104
      args.state.paddle.x += args.state.paddle_speed
      args.state.ball.x += args.state.paddle_speed if args.state.ball_launched == false
    end

    if args.state.ball.intersect_rect? args.state.paddle
      modify_ball_direction args
      args.outputs.sounds << 'sounds/bloop.wav'
      # We'll need to credit this if we leave it in the game
      # Bloop by andersmmg -- https://freesound.org/s/523423/ -- License: Attribution 4.0
    end

    if args.state.ball_launched
      if args.state.new_ball_x < args.state.play_x || args.state.new_ball_x > args.state.play_space_max_x - 10
        args.state.ball_x_direction *= -1
      end

      if args.state.new_ball_y < args.state.play_y || args.state.new_ball_y > args.state.play_space_max_y - 10
        args.state.ball_y_direction *= -1
      end
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
      end

      if Geometry.angle_within_range? test_angle, target_y, args.state.horizontal_quadrant_angle
        args.state.ball_y_direction *= -1
      end
      args.state.bricks_left -= brick.take_damage(args.state.ball_damage)
      if args.state.explosion
        explosion = Explosion.new(radius: 50, x: ball_center.x, y: ball_center.y, w: 100, h: 100)
        args.geometry.find_all_intersect_rect(explosion, args.state.bricks).each do |brick|
          brick.take_damage(args.state.ball_damage)
        end
        args.state.explosions << explosion
      end
      eliminate_destroyed_bricks args
      args.state.bricks.delete(brick) if brick.health <= 0
      args.outputs.sounds << 'sounds/brick.wav'
    end

    calculate_new_ball_position args if args.state.ball_launched
    move_ball args if args.state.ball_launched

    args.state.power_ups.each do |power_up|
      if args.geometry.intersect_rect? args.state.paddle, power_up
        power_up.call args
        args.state.power_ups.delete power_up
      else
        power_up.y -= args.state.power_up_speed
      end
    end


    if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? args.state.state_button))
      args.state.current_scene = :shop
    end

    args.outputs.labels << { x: 25, y: 45, text: "To Shop" }
    args.outputs.sprites << args.state.state_button

    args.outputs.borders << args.state.play_border
    args.outputs.labels << [1110, 50, "Bricks left: #{args.state.bricks_left}", 5, 1, 255, 255, 255]
    args.outputs.sprites << args.state.bricks
    args.outputs.sprites << args.state.paddle
    args.outputs.sprites << args.state.ball
    args.outputs.sprites << args.state.power_ups
    args.outputs.sprites << args.state.explosions
    args.outputs.labels << [50, 700, "$#{args.state.wallet}", 5, 1, 0, 255, 150]
  end

  def eliminate_destroyed_bricks args
    args.state.bricks.select { |brick| brick.health <= 0 }.each do |brick|
      args.state.bricks.delete brick
      random_percent = rand(100)
      case rand(100)
      when ..args.state.gold_brick_chance
        spawn_power_up args, brick, :gold
      end
    end
  end

  def spawn_power_up args, brick, type
    args.state.power_ups << PowerUp.new(x: brick.x, y: brick.y, w: 30, h: 30, type: type)
  end


  def set_quadrant_angles args
    args.state.horizontal_quadrant_angle ||= (
      Math.atan((args.state.brick_width / 2) / (args.state.brick_height / 2)) * 180 / Math::PI
    )

    args.state.vertical_quadrant_angle ||= (90 - args.state.horizontal_quadrant_angle)
  end

  def launch_ball args
    args.state.ball_launched = true
  end

  def setup_board args
    10.times do |j|
      (args.state.play_space_width / args.state.brick_width).to_i.times do |i|
        x = args.state.play_x + (i * args.state.brick_width)
        y = args.state.play_space_max_y - (j * args.state.brick_height) - args.state.brick_height
        next if rand(2) == 0
        args.state.bricks << Brick.new(x: x, y: y, w: args.state.brick_width, h: args.state.brick_height, base_health: rand(args.state.max_brick_health) + 1, health_multiplier: args.state.brick_health_multiplier)
      end
    end
    args.state.ball_launched = false
    args.state.refresh_board = false
    args.state.ball.x = args.state.paddle.x
    args.state.ball.y = args.state.paddle.y + args.state.paddle.h
  end

  def end_of_level args
    if args.state.bricks_left <= 0
      args.state.current_scene = :gameover
    elsif args.state.current_scene == :game && args.state.bricks.none?
      args.state.current_scene = :shop
      args.state.wallet += args.state.level_clear_bonus
      args.state.wallet += (args.state.wallet * args.state.interest).ceil
      args.state.brick_health_multiplier *= 10
      args.state.refresh_board = true
    end
  end

  def move_ball args
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
