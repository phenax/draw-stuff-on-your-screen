require "./sdl"

module Dsoys
  abstract class Drawable
    property color : Color?
    getter persist = true

    def self.draw_icon(renderer : SDL::Renderer, size : Int32, pos : Point)
    end

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

    def self.draw_icon(renderer : SDL::Renderer, size : Int32, pos : Point)
      renderer.draw_line(
        Point[(pos.x - size/2).to_i, pos.y],
        Point[(pos.x + size/2).to_i, pos.y])
    end

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
      points.any? { |p| p.distance(point) <= 5 }
    end
  end

  class RectDraw < Drawable
    property startPoint : Point
    property endPoint : Point

    def self.draw_icon(renderer : SDL::Renderer, size : Int32, pos : Point)
      renderer.draw_rect((pos.x - size/2).to_i, (pos.y - size/2).to_i, size, size)
    end

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
        Point[startPoint.x, endPoint.y],
        endPoint,
        Point[endPoint.x, startPoint.y],
        startPoint,
      ]
    end
  end

  class DeleteObjectDraw < Drawable
    getter persist = false

    def self.draw_icon(renderer : SDL::Renderer, size : Int32, pos : Point)
      renderer.draw_line(Point[(pos.x - size/2).to_i, (pos.y - size/2).to_i], Point[(pos.x + size/2).to_i, (pos.y + size/2).to_i])
      renderer.draw_line(Point[(pos.x + size/2).to_i, (pos.y - size/2).to_i], Point[(pos.x - size/2).to_i, (pos.y + size/2).to_i])
    end

    def update(point, drawables) : Array(Drawable)
      drawables.reject { |d| d.is_on_object(point) }
    end

    def draw(renderer : SDL::Renderer)
    end
  end

  class CircleDraw < Drawable
    property startPoint : Point
    property endPoint : Point

    def self.draw_icon(renderer : SDL::Renderer, size : Int32, pos : Point)
      renderer.draw_circle(pos, (size / 2).to_i)
    end

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
      renderer.draw_circle(center, radius.to_i)
      renderer.draw_circle(center, radius.to_i + 1)
      renderer.draw_circle(center, radius.to_i - 1)
    end

    def is_on_object(point : Point) : Bool
      (point.distance(center) - radius).abs <= 4
    end

    private def radius
      center.distance(pointOnCircumference)
    end

    private def center
      @startPoint.midpoint(@endPoint)
    end

    private def pointOnCircumference
      @endPoint
    end
  end
end
