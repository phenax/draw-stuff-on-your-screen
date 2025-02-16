require "sdl"

module Dsoys
  class Controls
    property buttons = [] of Button
    property draw_color = Color[255]
    property hovered_point = Point.new(0, 0)

    def initialize
      buttons.push(color_btn(Point.new(40, 100), Color[0, 255, 0]))
      buttons.push(color_btn(Point.new(40, 140), Color[255, 0, 0]))
      buttons.push(color_btn(Point.new(40, 180), Color[0, 0, 255]))
    end

    def color_btn(pos : Point, color : Color)
      btn = Button.new(pos) { @draw_color = color }
      btn.bg = color
      btn.size = 14
      btn
    end

    def draw(renderer : SDL::Renderer)
      buttons.each do |btn|
        btn.draw(renderer, btn.is_active(hovered_point.x, hovered_point.y))
      end
      # TODO: draw current color
    end

    def activate(x : Int, y : Int)
      buttons.each do |btn|
        btn.activate if btn.is_active(x, y)
      end
    end
  end

  class Button
    property bg : Color = Color[20, 20, 20]
    property size : Int32 = 14

    def initialize(@position : Point, &@on_click)
    end

    def is_active(x : Int, y : Int)
      dist = Math.sqrt((@position.x - x)**2 + (@position.y - y)**2)
      dist <= @size
    end

    def draw(renderer : SDL::Renderer, is_active : Bool = false)
      if is_active
        renderer.draw_color = Color[255]
        renderer.fill_circle(@position, @size + 2)
      end
      renderer.draw_color = bg
      renderer.fill_circle(@position, @size)
    end

    def activate
      @on_click.call
    end
  end
end
