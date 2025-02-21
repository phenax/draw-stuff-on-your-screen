require "./drawable"
require "./controls"

module Dsoys
  module AppState
    property drawables = [] of Dsoys::Drawable
    property current_drawable : Dsoys::Drawable?
    property controls = Controls.new

    private def handle_event(event : SDL::Event)
      case event
      when SDL::Event::Quit        then return :quit
      when SDL::Event::Keyboard    then on_keypress event if event.keydown?
      when SDL::Event::MouseMotion then on_mouse_move event
      when SDL::Event::MouseButton
        if event.pressed?
          on_mouse_press event
        else
          on_mouse_release event
        end
      end
    end

    private def on_keypress(event)
      case event.sym
      when .q?      then return :quit
      when .p?, .f? then controls.select_tool :free
      when .r?      then controls.select_tool :rect
      when .d?      then controls.select_tool :delete
      when .c?      then controls.select_tool :circle
      when .key_1?  then controls.select_color :teal
      when .key_2?  then controls.select_color :red
      when .key_3?  then controls.select_color :blue
      when .key_4?  then controls.select_color :purple
      when .key_5?  then controls.select_color :gray
      when .key_6?  then controls.select_color :yellow
      when .delete? then clear_drawables
      when .tab?    then controls.toggle_visible
      end
    end

    private def on_mouse_press(event)
      point = SDL::Point[event.x, event.y]
      @current_drawable ||= controls.current_drawable_class.new(point)
      controls.activate(event.x, event.y)
    end

    private def on_mouse_release(event)
      drawable = current_drawable
      if !drawable.nil? && drawable.persist
        drawables.push drawable
      end
      @current_drawable = nil
    end

    private def on_mouse_move(event)
      point = SDL::Point[event.x, event.y]
      if event.pressed?
        drawable = current_drawable
        @drawables = drawable.update(point, @drawables) unless drawable.nil?
      else
        controls.cursor_position = point
      end
    end

    private def clear_drawables
      @drawables = [] of Drawable
      @current_drawable = nil
    end
  end
end
