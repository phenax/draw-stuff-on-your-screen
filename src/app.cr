require "./drawable"
require "./controls"

module Dsoys
  class App
    property window : SDL::Window
    property renderer : SDL::Renderer
    property drawables = [] of Dsoys::Drawable
    property current_drawable : Dsoys::Drawable?
    property controls = Controls.new

    def initialize
      SDL.init(SDL::Init::VIDEO)

      @window = SDL::Window.new("Draw window", 0, 0)
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
          on_mouse_press(event)
        else
          drawables.push current_drawable.not_nil! unless current_drawable.nil?
          @current_drawable = nil
        end
      when SDL::Event::MouseMotion
        point = SDL::Point.new(event.x, event.y)
        if event.pressed?
          current_drawable.with_nullable { |d| d.update(point) }
        else
          controls.hovered_point = point
        end
      end
    end

    def draw
      current_drawable.with_nullable { |d| d.color ||= controls.draw_color }
      drawables.each { |d| d.draw(renderer) }
      current_drawable.with_nullable { |d| d.draw(renderer) }

      controls.draw(renderer)
    end

    def on_mouse_press(event)
      controls.activate(event.x, event.y)
    end
  end
end
