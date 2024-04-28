require 'app/brick'
def tick args
  # right now menu and game are totally separate, so just comment out which one you want

  menu args
  # game args
end

def menu args
  args.state.upgrade_1_count ||= 0
  args.state.upgrade_2_count ||= 0
  args.state.upgrade_3_count ||= 0
  args.state.upgrades ||= []

  if args.state.tick_count == 0
    args.state.upgrades << Upgrade.new(x: 100, y: 100, w: 200, h: 200, r: 255, g: 0, b: 0, label_text: "Upgrade 1", proc: -> { args.state.upgrade_1_count += 1 })
    args.state.upgrades << Upgrade.new(x: 400, y: 100, w: 200, h: 200, r: 255, g: 0, b: 0, label_text: "Upgrade 2", proc: -> { args.state.upgrade_2_count += 1 })
    args.state.upgrades << Upgrade.new(x: 700, y: 100, w: 200, h: 200, r: 255, g: 0, b: 0, label_text: "Upgrade 3", proc: -> { args.state.upgrade_3_count += 1 })
  end

  args.state.upgrades.each do |upgrade|
    args.outputs.labels << upgrade.label
    args.outputs.borders << upgrade
  end

  if args.inputs.mouse.click
    args.state.upgrades.each do |upgrade|
      next unless args.inputs.mouse.inside_rect? upgrade
      upgrade.call
      break
    end
  end

  args.outputs.labels << [640, 700, "Upgrade 1 count: #{args.state.upgrade_1_count}", 5, 1, 0, 0, 0]
  args.outputs.labels << [640, 650, "Upgrade 2 count: #{args.state.upgrade_2_count}", 5, 1, 0, 0, 0]
  args.outputs.labels << [640, 600, "Upgrade 3 count: #{args.state.upgrade_3_count}", 5, 1, 0, 0, 0]
end

class Upgrade
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x,
  :tile_y, :tile_w, :tile_h, :flip_horizontally,
  :flip_vertically, :angle_anchor_x, :angle_anchor_y, :id,
  :angle_x, :angle_y, :z,
  :source_x, :source_y, :source_w, :source_h, :blendmode_enum,
  :source_x2, :source_y2, :source_x3, :source_y3, :x2, :y2, :x3, :y3,
  :anchor_x, :anchor_y

  def initialize(x:, y:, w:, h:, r:, g:, b:, label_text:, proc:)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.r = r
    self.g = g
    self.b = b
    @proc = proc
    @label_text = label_text
  end

  def call
    proc.call
  end

  # omg the work we'll have to do to render labels that fit into a box and in the right
  # spot and making sure it's not too long is going to be so annoying,
  # so we might just put that part off, but like a button class that does
  # something like that might be good.

  def label
    { x: (x), y: (y + h/2), h: h, w: w, text: @label_text, r: 0, g: 0, b: 0}
  end

  def primitive_marker
    :border
  end
end

def game args
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