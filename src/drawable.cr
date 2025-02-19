require "./sdl"

module Dsoys
  abstract class Drawable
    property color : Color?
    getter persist = true

    def initialize(point : Point)
    end

    abstract def update(point : Point, drawables : Array(Drawable)) : Array(Drawable)
    abstract def draw(renderer : SDL::Renderer)

    def is_on_object(point : Point) : Bool
      false
    end
  end

  class FreeDraw < Drawable
    property points = [] of Point

    def initialize(point : Point)
    end

    def update(point, drawables) : Array(Drawable)
      points.push(point)

      drawables
    end

    def draw(renderer)
      renderer.draw_color = color || Color[255]
      renderer.draw_thick_line(points, 3)
    end

    def is_on_object(point : Point) : Bool
      !(points.find { |p| p.distance(point) <= 5 }).nil?
    end
  end

  class RectDraw < Drawable
    property startPoint : Point
    property endPoint : Point

    def initialize(point : Point)
      @startPoint = point
      @endPoint = point
    end

    def update(point, drawables) : Array(Drawable)
      @endPoint = point

      drawables
    end

    def draw(renderer)
      renderer.draw_color = color || Color[255]
      renderer.draw_thick_line(rect_points, 3)
    end

    def is_on_object(point : Point) : Bool
      rect_points.each.cons_pair.any? { |p1, p2|
        sum_dists = point.distance(p1) + point.distance(p2)
        length = p1.distance(p2)
        length >= sum_dists - 0.1
      }
    end

    private def rect_points
      [
        startPoint,
        Point.new(startPoint.x, endPoint.y),
        endPoint,
        Point.new(endPoint.x, startPoint.y),
        startPoint,
      ]
    end
  end

  class DeleteObjectDraw < Drawable
    getter persist = false

    def update(point, drawables) : Array(Drawable)
      drawables.reject { |d| d.is_on_object(point) }
    end

    def draw(renderer : SDL::Renderer)
    end
  end
end
