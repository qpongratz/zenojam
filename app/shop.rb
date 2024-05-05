class Shop
  def all_upgrades(args)
    @all_upgrades ||= [
      Upgrade.new(name: "Double Ball Damage", cost: 5, proc: -> { args.state.ball_damage *= 2 }, uses: 30),
      Upgrade.new(name: "Double Brick Health Mult", cost: 5, proc: -> { args.state.brick_health_multiplier *= 2 }, uses: 20),
      Upgrade.new(name: "Double Gold Bricks", cost: 10, proc: -> {args.state.gold_brick_chance += 10 }, uses: 1),
      Upgrade.new(name: "Paddle Size", cost: 5, proc: -> { args.state.paddle.w += 10; args.state.paddle_width += 10 }, uses: 4),
      Upgrade.new(name: "Explosion", cost: 100, proc: -> { args.state.explosion = true }, uses: 1),
      Upgrade.new(name: "Explosion Radius", cost: 20, proc: -> { args.state.explosion_radius += 25 }, uses: 3),
      Upgrade.new(name: "Brick Health Levels", cost: 5, proc: -> { args.state.max_brick_health += 1 }, uses: 6),
      Upgrade.new(name: "Paddle Speed", cost: 10, proc: -> { args.state.paddle_speed += 1 }, uses: 5),
      Upgrade.new(name: "Slow Power-Up Speed", cost: 5, proc: -> { args.state.power_up_speed -= 1 }, uses: 5),
      Upgrade.new(name: "Short Paddle Curse", cost: 100, proc: -> { args.state.paddle_shrink_chance += 10; args.state.ball_damage *=100 }, uses: 1, description_text: "But 100x damage!"),
      Upgrade.new(name: "Interest Gained", cost: 20, proc: -> { args.state.interest += 0.1 }, uses: 3),

    ]
  end

  def menu args
    args.state.upgrades ||= all_upgrades(args).select do |upgrade|
      next if upgrade.name == "Explosion Radius" && !args.state.explosion
      next if upgrade.uses == 0
      upgrade
    end.shuffle.take(3)

    args.state.buttons ||= []


    if args.state.buttons.empty?
      args.state.upgrades.each_with_index do |upgrade, index|
        args.state.buttons << Button.new(x: (220 + 300 * index), y: 80, w: 250, h: 180, upgrade: upgrade)
      end
    end


    args.state.buttons.each do |button|
      args.outputs.labels << button.labels
      args.outputs.sprites << button
    end

    if args.inputs.mouse.click
      args.state.buttons.each do |upgrade|
        next unless args.inputs.mouse.inside_rect? upgrade
        upgrade.call args
        break
      end
    end

    args.outputs.labels << { x: 25, y: 45, text: "To Game", r: 255, g: 255, b: 255 }

    if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? args.state.state_button))
      args.state.current_scene = :game
      args.state.upgrades = nil
      args.state.buttons = []
    end

    args.outputs.sprites << args.state.state_button
    args.outputs.labels << [640, 700, "Ball Speed: #{args.state.ball_speed}", 5, 1, 255, 255, 255]
    args.outputs.labels << [640, 650, "Brick Health Mult: #{args.state.brick_health_multiplier}", 5, 1, 255, 255, 255]
    args.outputs.labels << [640, 600, "Ball Damage: #{args.state.ball_damage}", 5, 1, 255, 255, 255]
    args.outputs.labels << [640, 550, "Gold Bricks: #{args.state.gold_brick_chance}", 5, 1, 255, 255, 255]
    args.outputs.labels << [50, 700, "$#{args.state.wallet}", 5, 1, 0, 255, 150]
  end
end

class Upgrade
  attr_accessor :name, :cost, :proc, :uses, :description_text

  def initialize(name:, cost:, proc:, uses: -1, description_text: "")
    @name = name
    @cost = cost
    @proc = proc
    self.uses = uses
    @description_text = description_text
  end

  def cost_text
    "$#{cost}"
  end

  def uses_text
    return "Infinite" if uses.negative?
    "#{uses} Available"
  end

  def call args
    return if uses == 0
    return if cost > args.state.wallet

    self.uses -= 1
    args.state.wallet -= cost
    proc.call
  end
end

class Button
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x,
  :tile_y, :tile_w, :tile_h, :flip_horizontally,
  :flip_vertically, :angle_anchor_x, :angle_anchor_y, :id,
  :angle_x, :angle_y, :z,
  :source_x, :source_y, :source_w, :source_h, :blendmode_enum,
  :source_x2, :source_y2, :source_x3, :source_y3, :x2, :y2, :x3, :y3,
  :anchor_x, :anchor_y, :upgrade

  def initialize(x:, y:, w:, h:, upgrade:)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    @upgrade = upgrade
  end

  def call(...)
    upgrade.call(...)
  end

  def labels
    [
      { x: (x + 10), y: (y + h - 20), h: h, w: w, text: upgrade.name, size_enum: 0,  r: 255, g: 255, b: 255},
      { x: (x + 10), y: (y + h - 40), h: h, w: w, text: upgrade.description_text, r: 255, g: 255, b: 255},
      { x: (x + 10), y: (y + h - 60), h: h, w: w, text: upgrade.cost_text, r: 255, g: 255, b: 255},
      { x: (x + 10), y: (y + h - 80), h: h, w: w, text: upgrade.uses_text, r: 255, g: 255, b: 255},
    ]
  end

  def path
    'sprites/kenny/controls/line-light/square.png'
  end

  def primitive_marker
    :sprite
  end
end
