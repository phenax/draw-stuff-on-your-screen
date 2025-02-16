require "sdl"

module Dsoys
  abstract class Drawable
    property color : Color?

    abstract def update(point : SDL::Point)
    abstract def draw(renderer : SDL::Renderer)
  end

  class FreeDraw < Drawable
    property points = [] of SDL::Point

    def initialize(point : SDL::Point)
    end

    def update(point : SDL::Point)
      points.push(point)
    end

    def draw(renderer)
      renderer.draw_color = color || Color[255]
      renderer.draw_thick_line(points, 3)
    end
  end

  class RectDraw < Drawable
    property startPoint : Point
    property endPoint : Point

    def initialize(point : SDL::Point)
      @startPoint = point
      @endPoint = point
    end

    def update(point : Point)
      @endPoint = point
    end

    def draw(renderer)
      renderer.draw_color = color || Color[255]
      points = [
        startPoint,
        Point.new(startPoint.x, endPoint.y),
        endPoint,
        Point.new(endPoint.x, startPoint.y),
        startPoint,
      ]
      renderer.draw_thick_line(points, 3)
    end
  end
end
