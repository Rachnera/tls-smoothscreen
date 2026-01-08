
# Remove F6 from "configurable" buttons
ConfigScene::Categs[:system][:list].delete(:screenratio)

# Add ability to enable/disable fullscreen from settings
class Window_SystemOptions < Window_Command
  alias yanfly_283_make_command_list make_command_list
  def make_command_list
    add_command("Display mode", :fullscreen)
    add_command("Anti-aliasing", :antialiasing)

    yanfly_283_make_command_list

    @help_descriptions[:fullscreen] = "Toggle between fullscreen and windowed displays."
    @help_descriptions[:antialiasing] = "Disable anti-aliasing, either for aesthetic reasons\nor to improve performances."
  end

  alias yanfly_283_draw_item draw_item
  def draw_item(index)
    if [:fullscreen, :antialiasing].include? @list[index][:symbol]
      reset_font_settings
      rect = item_rect(index)
      contents.clear_rect(rect)
      draw_toggle(rect, index, @list[index][:symbol])

      return
    end

    yanfly_283_draw_item(index)
  end

  alias yanfly_283_draw_toggle draw_toggle
  def draw_toggle(rect, index, symbol)
    extra_toggles = {
      fullscreen: {
        options: ["Windowed", "Fullscreen"],
      },
      antialiasing: {
        options: ["Disabled", "Enabled"],
      },
    }

    if extra_toggles.keys.include?(symbol)
      name = @list[index][:name]
      enabled =
        if symbol == :fullscreen
          Graphics.fullscreen
        elsif symbol == :antialiasing
          Graphics.effect_id > 0
        end

      draw_text(0, rect.y, contents.width/2, line_height, name, 1)

      dx = contents.width/2
      change_color(normal_color, !enabled)
      draw_text(dx, rect.y, contents.width/4, line_height, extra_toggles[symbol][:options][0], 1)

      dx += contents.width/4
      change_color(normal_color, enabled)
      draw_text(dx, rect.y, contents.width/4, line_height, extra_toggles[symbol][:options][1], 1)

      return
    end

    yanfly_283_draw_toggle(rect, index, symbol)
  end

  alias yanfly_283_cursor_change cursor_change
  def cursor_change(direction)
    new_value = direction == :left ? false : true

    if [:fullscreen, :antialiasing].include?(current_symbol)
      current_value =
        if current_symbol == :fullscreen
          Graphics.fullscreen
        elsif current_symbol == :antialiasing
          Graphics.effect_id > 0
        end

      if new_value != current_value
        if current_symbol == :fullscreen
          Graphics.toggle_fullscreen!
        elsif current_symbol == :antialiasing
          Graphics.effect_id = (Graphics.effect_id + 1) % 2
        end

        Graphics.save_settings
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
    Graphics.effect_id = 1
    Graphics.save_settings

    yanfly_283_command_reset_opts
  end
end
