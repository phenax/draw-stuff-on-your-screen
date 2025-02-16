require "./drawable"

module Dsoys
  class App
    property window : SDL::Window
    property renderer : SDL::Renderer
    property drawables = [] of Dsoys::Drawable
    property current_drawable : Dsoys::Drawable?

    def initialize
      SDL.init(SDL::Init::VIDEO)

      @window = SDL::Window.new("Basic window", 0, 0)
      window.fullscreen = SDL::Window::Fullscreen::FULLSCREEN_DESKTOP
      window.bordered = false
      window.grab = false

      @renderer = SDL::Renderer.new(window)
      renderer.draw_blend_mode = SDL::BlendMode::ADD

      LibSDL.set_window_opacity(window, 0.8)
    end

    def finalize
      SDL.quit
    end

    def loop
      event = SDL::Event.wait
      renderer.draw_color = SDL::Color[0]

      action = handle_event event

      renderer.clear
      draw

      window.update
      renderer.present

      return action
    end

    def handle_event(event : SDL::Event)
      case event
      when SDL::Event::Quit
        return :quit
      when SDL::Event::Keyboard
        return :quit if event.sym.q?
      when SDL::Event::MouseButton
        if event.pressed?
          @current_drawable ||= Dsoys::FreeDraw.new
        else
          drawables.push current_drawable.not_nil! unless current_drawable.nil?
          @current_drawable = nil
        end
      when SDL::Event::MouseMotion
        if event.pressed?
          current_drawable.with_nullable do |d|
            d.update(SDL::Point.new(event.x, event.y))
          end
        end
      end
    end

    def draw
      drawables.each { |d| d.draw(renderer) }
      current_drawable.with_nullable do |d|
        d.draw(renderer)
      end
    end
  end
end
