
# Remove F6 from "configurable" buttons
ConfigScene::Categs[:system][:list].delete(:screenratio)

# Add ability to enable/disable fullscreen from settings
class Window_SystemOptions < Window_Command
  alias yanfly_283_make_command_list make_command_list
  def make_command_list
    add_command("Display mode", :fullscreen)

    yanfly_283_make_command_list

    @help_descriptions[:fullscreen] = "Toggle between fullscreen and windowed displays."
  end

  alias yanfly_283_draw_item draw_item
  def draw_item(index)
    if @list[index][:symbol] == :fullscreen
      reset_font_settings
      rect = item_rect(index)
      contents.clear_rect(rect)
      draw_toggle(rect, index, :fullscreen)

      return
    end

    yanfly_283_draw_item(index)
  end

  alias yanfly_283_draw_toggle draw_toggle
  def draw_toggle(rect, index, symbol)
    if symbol == :fullscreen
      name = @list[index][:name]
      draw_text(0, rect.y, contents.width/2, line_height, name, 1)
      #---
      dx = contents.width / 2
      enabled = Graphics.fullscreen
      dx = contents.width/2
      change_color(normal_color, !enabled)
      option1 = "Windowed"
      draw_text(dx, rect.y, contents.width/4, line_height, option1, 1)
      dx += contents.width/4
      change_color(normal_color, enabled)
      option2 = "Fullscreen"
      draw_text(dx, rect.y, contents.width/4, line_height, option2, 1)

      return
    end

    yanfly_283_draw_toggle(rect, index, symbol)
  end

  alias yanfly_283_cursor_change cursor_change
  def cursor_change(direction)
    if current_symbol == :fullscreen
      value = direction == :left ? false : true
      if value != Graphics.fullscreen
        Graphics.toggle_fullscreen!
        Sound.play_cursor
        draw_item(index)
      end

      return
    end

    yanfly_283_cursor_change(direction)
  end
end

class Scene_System < Scene_MenuBase
  alias yanfly_283_command_reset_opts command_reset_opts
  def command_reset_opts
    Graphics.toggle_fullscreen! unless Graphics.fullscreen

    yanfly_283_command_reset_opts
  end
end
