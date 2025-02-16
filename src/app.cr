require "./drawable"
require "./controls"

module Dsoys
  class App
    property window : SDL::Window
    property renderer : SDL::Renderer
    property drawables = [] of Dsoys::Drawable
    property current_drawable : Dsoys::Drawable?
    property controls = Controls.new
    property current_drawable_class = Dsoys::FreeDraw

    def initialize
      SDL.init(SDL::Init::VIDEO)

      @window = SDL::Window.new("Dsoys: Draw stuff on your screen", 0, 0,
        SDL::Window::Position::UNDEFINED, SDL::Window::Position::UNDEFINED,
        SDL::Window::Flags::SHOWN | SDL::Window::Flags::ALWAYS_ON_TOP | SDL::Window::Flags::ALLOW_HIGHDPI)
      window.fullscreen = SDL::Window::Fullscreen::FULLSCREEN_DESKTOP
      window.bordered = false
      window.grab = false

      @renderer = SDL::Renderer.new(window, flags: SDL::Renderer::Flags::ACCELERATED | SDL::Renderer::Flags::PRESENTVSYNC)
      renderer.draw_blend_mode = SDL::BlendMode::BLEND
      LibSDL.set_window_opacity(window, 0.5)

      @cursor = LibSDL.create_system_cursor(LibSDL::SystemCursor::HAND)
      LibSDL.set_cursor(@cursor)
    end

    def finalize
      SDL.quit
      LibSDL.free_cursor(@cursor)
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
        on_keyboard_event(event)
      when SDL::Event::MouseButton
        if event.pressed?
          on_mouse_press(event)
        else
          on_mouse_release(event)
        end
      when SDL::Event::MouseMotion
        on_mouse_move(event)
      end
    end

    def draw
      current_drawable.with_nullable { |d| d.color ||= controls.draw_color }
      drawables.each { |d| d.draw(renderer) }
      current_drawable.with_nullable { |d| d.draw(renderer) }

      controls.draw(renderer)
    end

    def on_keyboard_event(event)
      return unless event.keydown?

      case event.sym
      when LibSDL::Keycode::Q
        return :quit
      when LibSDL::Keycode::D
        @current_drawable_class = Dsoys::FreeDraw
      when LibSDL::Keycode::R
        @current_drawable_class = Dsoys::RectDraw
      end
    end

    def on_mouse_press(event)
      point = SDL::Point.new(event.x, event.y)
      @current_drawable ||= current_drawable_class.new(point)
      controls.activate(event.x, event.y)
    end

    def on_mouse_release(event)
      drawables.push current_drawable.not_nil! unless current_drawable.nil?
      @current_drawable = nil
    end

    def on_mouse_move(event)
      point = SDL::Point.new(event.x, event.y)
      if event.pressed?
        current_drawable.with_nullable { |d| d.update(point) }
      else
        controls.cursor_position = point
      end
    end
  end
end
