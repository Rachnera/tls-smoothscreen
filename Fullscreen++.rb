=begin
  Fullscreen++ v4.0.1 for XP, VX and VXace by Zeus81
  
  User guide:
            F11 : toggle fullscreen
    Shift + F11 : switch aspects (stretch - keep ratio - integer)
    Ctrl  + F11 : switch effects (setup effects in Game.ini)
    
  Shaders:
    SimpleScale(scale:0, interpolation:1)
    CAS(scale:0, sharpness:0.9, preset:0)
    FSR(scale:0, sharpness:0.9)
    RAA(scale:0, interpolation:1, sharpness:1.0)
    MMPX(scale:0, interpolation:1, threshold:0.2, RAA_Sharpness:0.0)
    ScaleFX(scale:0, interpolation:1, filterAA:false, filterCorners:true, threshold:0.5, RAA_Sharpness:0.0)
    SMAA(preset:3, colorEdgeDetection:true, localContrastAdapt:2.0, threshold:0.8)
    Blur(mode:0, quality:5, radius:1.0, angle:0.0, centerX:0.5, centerY:0.5, downscale:0)
    Glow(blendMode:8, blendOpacity,:1.0 lumaThreshold:0.0, thresholdSoftness:0.0, intensityR:0.5, intensityG:0.5, intensityB:0.5, blurMode:0, blurQuality:5, blurRadius:1.0, blurAngle:0.0, blurCenterX:0.5, blurCenterY:0.5)
    Palette(paletteId:1, smooth:false, ditherMode:1, ditherAnime:0, ditherAmount:0, sharpness:0.4, customColors:[])
    Daltonize(anomaly:0, severity:1.0)
    Tweaks(hue:0, saturation:1.0, brightness:1.0, contrast:1.0, luminosity:1.0, gamma:1.0, sharpness:0.0)
    
  Aliased methods:
    Graphics::update, ::freeze, ::transition
    Sprite::update
    
  Overridden methods:
    Graphics::wait, ::fadeout, ::fadein
    
  License:
    MIT (Free for commercial use)
  
  Self Promotion:
    Check out my game: https://store.steampowered.com/app/3817260/The_Myth_of_a_Godslayer/
=end

steam_app_id = 0
exit if -1 == r = Zeus::DLL.Fullscreen.exist? ? Zeus::DLL.Fullscreen.Steam_Initialize(steam_app_id) : 0
$STEAM = r == 1

($imported ||= {})[:Zeus_Fullscreen] = __FILE__
raise 'Zeus Module v1 or higher is required' unless $imported[:Zeus_Module].to_i >= 1

module Graphics
  unless @buffer
    @fullscreen, @vsync, @black_frame, @keep_aspect, @overscan, @background, @effect_id, @effects         , @buffer =
          false,   true,        false,            1,       0.0,      ['',2],          0, ['SimpleScale()'], [].pack('x16').freeze!
  end
  
  class << self
    attr_accessor :fullscreen, :vsync, :black_frame, :keep_aspect, :overscan, :background, :effect_id, :effects
    
    def settings()         [@fullscreen, @vsync, @black_frame, @keep_aspect, @overscan, @background[0,2], @effect_id, @effects]           end
    def settings=(settings) @fullscreen, @vsync, @black_frame, @keep_aspect, @overscan, @background[0,2], @effect_id, @effects = settings end
    def load_settings(filename=Zeus::OS.ini_name)
      if File.extname(filename) == '.ini'
        @fullscreen    = Zeus::Ini.read(filename, 'Fullscreen++', 'Fullscreen', 'false').to_b
        @vsync         = Zeus::Ini.read(filename, 'Fullscreen++', 'VSync'     , 'true' ).to_b
        @black_frame   = Zeus::Ini.read(filename, 'Fullscreen++', 'BlackFrame', 'false').to_b
        @keep_aspect   = Zeus::Ini.read(filename, 'Fullscreen++', 'KeepAspect', '1').to_i
        @overscan      = Zeus::Ini.read(filename, 'Fullscreen++', 'Overscan'  , '0').to_f
        @background[0] = Zeus::Ini.read(filename, 'Fullscreen++', 'BackEffect', nil).to_s
        @background[1] = Zeus::Ini.read(filename, 'Fullscreen++', 'BackAspect', '2').to_i
        @effect_id     = Zeus::Ini.read(filename, 'Fullscreen++', 'EffectId'  , '0').to_i
        @effects = []; e = nil; i = -1
        @effects << e while e = Zeus::Ini.read(filename, 'Fullscreen++', "Effect#{i+=1}")
        @effects << 'SimpleScale()' if @effects.empty?
      else self.settings = load_data(filename)
      end
      nil
    rescue; msgbox('Failed to load settings')
    end
    def save_settings(filename=Zeus::OS.ini_name)
      if File.extname(filename) == '.ini'
        Zeus::Ini.write(filename, 'Fullscreen++', 'Fullscreen', @fullscreen  ? 'true' : 'false')
        Zeus::Ini.write(filename, 'Fullscreen++', 'VSync'     , @vsync       ? 'true' : 'false')
        Zeus::Ini.write(filename, 'Fullscreen++', 'BlackFrame', @black_frame ? 'true' : 'false')
        Zeus::Ini.write(filename, 'Fullscreen++', 'KeepAspect', @keep_aspect)
        Zeus::Ini.write(filename, 'Fullscreen++', 'Overscan'  , @overscan)
        Zeus::Ini.write(filename, 'Fullscreen++', 'BackEffect', @background[0])
        Zeus::Ini.write(filename, 'Fullscreen++', 'BackAspect', @background[1])
        Zeus::Ini.write(filename, 'Fullscreen++', 'EffectId'  , @effect_id)
        @effects.each_with_index {|e,i| Zeus::Ini.write(filename, 'Fullscreen++', "Effect#{i}", e)}
      else save_data(settings, filename)
      end
      nil
    rescue; msgbox('Failed to save settings')
    end
    
    def monitor_info(info=nil)
      monitor = Zeus::DLL.User32.MonitorFromWindow(hwnd, 2) # MONITOR_DEFAULTTONEAREST
      Zeus::DLL.User32.GetMonitorInfoW(monitor, @info ||= [104].pack('Lx100').freeze!)
      case info
      when :full; r = @info.unpack('@4l4') ; r[2]-=r[0]; r[3]-=r[1]; r
      when :work; r = @info.unpack('@20l4'); r[2]-=r[0]; r[3]-=r[1]; r
      when :flag; @info.unpack('@36L')[0]
      when :name; @info.unpack('@40a*')[0]
      else        @info.unpack('@4L9a*')
      end
    end
    def monitor_frequency
      Zeus::DLL.User32.EnumDisplaySettingsW(monitor_info(:name), -1, @dev_mode ||= [220].pack('x68Sx150').freeze!) # ENUM_CURRENT_SETTINGS
      @dev_mode.unpack('@184L')[0]
    end
    
    def d3d?()                    @d3d                                                                   end
    def rgss_fullscreen?()        (r = monitor_info(:full))[2] == 640 and r[3] == 480                    end
    def toggle_rgss_fullscreen!() Zeus::DLL.User32.SendMessage(hwnd, 273, 67539, 0); @fullscreen = false end
    def toggle_fullscreen!()      rgss_fullscreen? ? toggle_rgss_fullscreen! : @fullscreen ^= true       end
    
    def focus?
      Zeus::DLL.Fullscreen.Steam_RunCallbacks if $STEAM
      foreground = Zeus::DLL.User32.GetForegroundWindow == hwnd
      if $imported[:XAudio]
        (@volume = XAudio.volume; XAudio.volume = 0.0) if !foreground and !@volume
        (XAudio.volume = @volume; @volume       = nil) if  foreground and  @volume
      end
      foreground and !($STEAM and Zeus::DLL.Fullscreen.Steam_GameOverlayActivated?)
    end
    def update_fullscreen
      (frame_reset; zeus_update; self.frame_count -= 1) until focus?
      if 1 == @F11 = Zeus::DLL.User32.GetAsyncKeyState(122)[15] == 1 ? @F11==0 ? 1 : 2 : 0
        case (Input.press?(:SHIFT) ? 1 : 0) | (Input.press?(:CTRL) ? 2 : 0) | (Input.press?(:ALT) ? 4 : 0)
        when 2; @effect_id   = (@effect_id   + 1) % @effects.size
        when 1; @keep_aspect = (@keep_aspect + 1) % 3
        when 0; toggle_fullscreen!
        end
        save_settings
      end
      if @background_hash != @background.hash
        @background[2] = !@background[0].empty? && (Cache.picture(@background[0]) rescue nil)
        bitmap_address = @background[2] ? @background[2].to_int : 0
        @background_str = ["#{@background[0]}\0".to_utf16!, @background[1], bitmap_address].pack('pLL').freeze!
        @background_hash = @background.hash
      end
      if transition?
        @transition_sprite.update
        @transition_sprite &&= @transition_sprite.dispose unless @transition_sprite.transition?
      end
      if Zeus::DLL.Fullscreen.exist? and @d3d != false
        update_d3d_mode if $xp or @d3d == nil
      elsif rgss_fullscreen?
        @fullscreen = false
      elsif Zeus::OS.steamBigPicture? ? @fullscreen = !Zeus::OS.steamOSGameMode? : @fullscreen
        update_fullscreen_mode
      else
        update_windowed_mode
      end
    end
    
    def update_d3d_mode
      unless @d3d
        toggle_rgss_fullscreen! if rgss_fullscreen?
        return unless @d3d = Zeus::DLL.Fullscreen.Initialize?(hwnd, $TEST)
        unless $xp
          fps = frame_rate
          class << Graphics
            attr_accessor :frame_rate
            alias zeus_update update_d3d_mode
            def frame_reset() Zeus::DLL.Fullscreen.FrameReset; @drop_next_frame = nil end
          end
          self.frame_rate = fps
          @frame_drop_threshold = 0
        end
      end
      
      @fullscreen = true if Zeus::OS.steamBigPicture?
      if !$xp
        @frame_dropped = !bmp = frozen? ? @freeze_bmp : !@drop_next_frame && snap_to_bitmap
        self.frame_count += 1
      elsif @frame_dropped
        return
      end
      
      case $game_map and $rgss
      when :xp   ; x = $game_map.display_x / 4 ; y = $game_map.display_y / 4
      when :vx   ; x = $game_map.display_x / 8 ; y = $game_map.display_y / 8
      when :vxace; x = $game_map.display_x * 32; y = $game_map.display_y * 32
      else         x = y = 0
      end
      (x *= $game_map.effects.zoom_x; y *= $game_map.effects.zoom_y) if $imported[:Zeus_Map_Effects] and $game_map and $game_map.effects.active
      
      shutdown if -1 == r = Zeus::DLL.Fullscreen.Update(bmp || :nil, width, height, frame_rate, @fullscreen, @vsync, @black_frame, @keep_aspect, @overscan.to_f, x.floor%256, y.floor%256, @background_str, @effects[@effect_id] || 'SimpleScale()')
      @drop_next_frame = r==1
      if bmp
        @d3d_bmp.dispose if @d3d_bmp and !@d3d_bmp.disposed?
        @d3d_bmp = bmp != @freeze_bmp ? bmp : nil
      end
      nil
    end
    
    def shutdown
      Zeus::DLL.Fullscreen.Steam_Shutdown if $STEAM
      Zeus::DLL.User32.DestroyWindow(@fullscreen_hwnd) if @fullscreen_hwnd
      Zeus::DLL.Fullscreen.Dispose if @d3d
      ZInput.shutdown if $imported[:Zeus_Input]
      GDIP.shutdown if $imported[:Zeus_GDIP]
      exit
    end
    
    def update_fullscreen_mode
      unless @fullscreen_hwnd
        x, y, w, h = r = monitor_info(info = !$xp && Zeus::OS.proton? && !Zeus::OS.steamBigPicture? ? :work : :full)
        h -= 1 if info == :work and r == monitor_info(:full)
        @fullscreen_hwnd = Zeus::DLL.User32.CreateWindowExW(0x0800_0080, "Static\0".to_utf16!, nil, # WS_EX_NOACTIVATE | WS_EX_TOOLWINDOW
                                                            0x9000_000D, x, y, w, h, 0, 0, 0, nil) # WS_VISIBLE | WS_POPUP | SS_OWNERDRAW
        Zeus::DLL.User32.ShowWindow(hwnd, 9) if @windowed_data and @windowed_data[10] == 5 # SW_RESTORE
        style = Zeus::DLL.User32.GetWindowLong(hwnd, -16) & ~0x00C5_0000 # WS_CAPTION | WS_SIZEBOX | WS_MAXIMIZEBOX
        Zeus::DLL.User32.SetWindowLong(hwnd, -16, style) # GWL_STYLE
      end
      
      if !$xp and @keep_aspect > 0 and Zeus::OS.proton?
        Zeus::DLL.User32.GetWindowRect(@fullscreen_hwnd, @buffer)
        x, y, w, h = @buffer.unpack('l4'); w -= x; h -= y
      else x, y, w, h = monitor_info(:full)
      end
      x, y, cx, cy, cw, ch = 0, 0, x, y, w, h if $xp
      if @keep_aspect > 0
        scale = Math.min(w / width.to_f, h / height.to_f)
        scale = Math.max(1, scale.floor) if @keep_aspect > 1
        x += (w - w = (scale * width ).round) / 2
        y += (h - h = (scale * height).round) / 2
      end
      if draw_background = @fullscreen_data != @fullscreen_data = [x, y, w, h, @background.hash]
        x, y = cx+(cw-w=width)/2, cy+(ch-h=height)/2 if $xp
        flags = 0x0013 | ($xp || @keep_aspect > 0 ? 0x0040 : 0x0080) # SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE | (SWP_SHOW_WINDOW : SWP_HIDE_WINDOW)
        Zeus::DLL.User32.SetWindowPos(@fullscreen_hwnd, $xp ? -1 : 0, 0, 0, 0, 0, 0x0013) # $xp ? HWND_TOPMOST : HWND_TOP
        Zeus::DLL.User32.SetWindowPos(hwnd, $xp ? 0 : -1, x, y, w, h, 0x0000) # $xp ? HWND_TOP : HWND_TOPMOST
      end
      
      hdc = Zeus::DLL.User32.GetDC(@fullscreen_hwnd) if draw_background or $xp
      if draw_background
        Zeus::DLL.User32.GetClientRect(@fullscreen_hwnd, @buffer)
        Zeus::DLL.User32.FillRect(hdc, @buffer, black = Zeus::DLL.Gdi32.CreateSolidBrush(0x00_00_00))
        Zeus::DLL.Gdi32.DeleteObject(black)
        if bmp = @background[2]
          info = [40,bmp.width,bmp.height,1,32].pack('Ll2S2x24').freeze!
          client_w, client_h = @buffer.unpack('@8l2')
          case @background[1]
          when 1, 2; w = client_w ; h = client_w * bmp.height / bmp.width
                    (h = client_h ; w = client_h * bmp.width  / bmp.height) if @background[1] == 1 ? h > client_h : h < client_h
          when 3, 4; w = bmp.width; h = bmp.height
          else       w = client_w ; h = client_h
          end
          Zeus::DLL.Gdi32.SetStretchBltMode(hdc, 4) # HALFTONE
          if @background[1] == 4
            ((client_w-1)/w+1).times do |x| ((client_h-1)/h+1).times do |y|
              Zeus::DLL.Gdi32.StretchDIBits(hdc, x*w, y*h, w, h, 0, 0, w, h, bmp.address, info, 0, 0x00CC_0020) # DIB_RGB_COLORS, SRCCOPY
            end end
          else Zeus::DLL.Gdi32.StretchDIBits(hdc, (client_w-w)/2, (client_h-h)/2, w, h, 0, 0, bmp.width, bmp.height, bmp.address, info, 0, 0x00CC_0020) # DIB_RGB_COLORS, SRCCOPY
          end
        end
      end
      if $xp
        main_hdc = Zeus::DLL.User32.GetDC(hwnd)
        Zeus::DLL.Gdi32.SetStretchBltMode(hdc, 3) # COLORONCOLOR
        Zeus::DLL.Gdi32.StretchBlt(hdc, @fullscreen_data[0], @fullscreen_data[1], @fullscreen_data[2], @fullscreen_data[3],
                                   main_hdc, 0, 0, width, height, 0x00CC_0020) # SRCCOPY
        Zeus::DLL.User32.ReleaseDC(hwnd, main_hdc)
      end
      Zeus::DLL.User32.ReleaseDC(@fullscreen_hwnd, hdc) if hdc
      nil
    end
    
    def update_windowed_mode
      if @fullscreen_hwnd or !($xp or Zeus::OS.steamOSGameMode? or @windowed_data)
        style = Zeus::DLL.User32.GetWindowLong(hwnd, -16) | ($xp ? 0x00C0_0000 : 0x00C5_0000) # WS_CAPTION | WS_SIZEBOX | WS_MAXIMIZEBOX
        Zeus::DLL.User32.SetWindowLong(hwnd, -16, style) # GWL_STYLE
        if @windowed_data
          m = @windowed_data[10]
          Zeus::DLL.User32.ShowWindow(hwnd, 3) if m == 5 # SW_MAXIMIZE
          Zeus::DLL.User32.SetWindowPos(hwnd, -2, @windowed_data[m], @windowed_data[m+1], @windowed_data[m+2], @windowed_data[m+3], 0x0000) # HWND_NOTOPMOST
        elsif !($xp or Zeus::OS.steamOSGameMode?)
          @windowed_data = []
          work_x, work_y, work_w, work_h = monitor_info(:work)
          scale = Math.min(work_w/width, work_h/height)
          Zeus::DLL.User32.AdjustWindowRect(buf=[0, 0, width*scale, height*scale].pack('l4'), style, false)
          x, y, w, h = buf.unpack('l4'); w -= x; h -= y
          Zeus::DLL.User32.SetWindowPos(hwnd, -2, work_x+(work_w-w)/2, work_y+(work_h-h)/2, w, h, 0x0000) # HWND_NOTOPMOST
        end
        Zeus::DLL.User32.DestroyWindow(@fullscreen_hwnd) if @fullscreen_hwnd
        @fullscreen_hwnd = @fullscreen_data = nil
      end
      
      if @windowed_data
        m = Zeus::DLL.User32.IsZoomed?(hwnd) ? 5 : 0
        Zeus::DLL.User32.GetWindowRect(hwnd, @buffer)
        x, y, w, h = @buffer.unpack('l4'); w -= x; h -= y
        if (@windowed_data[m+2] != w or @windowed_data[m+3] != h or @windowed_data[m+4] != @keep_aspect or @windowed_data[10] != m) and (m == 0 or !Zeus::OS.proton?)
          if m == 5
            work_x, work_y, work_w, work_h = monitor_info(:work)
            ch = Zeus::DLL.User32.GetSystemMetrics(4) # SM_CYCAPTION
            case @keep_aspect
            when 0; w, h  = work_w, work_h
            when 1; scale = Math.min(work_w / width.to_f, (work_h-ch/2) / height.to_f)
            when 2; scale = Math.min(work_w/width, work_h/height)
            end
            w, h = (scale*width).round, (scale*height).round + ch if @keep_aspect > 0
            x, y = work_x+(work_w-w)/2, work_y+(work_h-h)/2
          elsif @keep_aspect > 0
            Zeus::DLL.User32.GetClientRect(hwnd, @buffer)
            client_w, client_h = @buffer.unpack('@8l2')
            scale_x, scale_y = client_w / width.to_f, client_h / height.to_f
            scale = w==@windowed_data[2] ? scale_y : h==@windowed_data[3] ? scale_x : Math.min(scale_x, scale_y)
            scale = Math.max(1, scale.floor) if @keep_aspect > 1
            w, h = (scale*width).round + w-client_w, (scale*height).round + h-client_h
          end
          Zeus::DLL.User32.SetWindowPos(hwnd, 0, x, y, w, h, 0x0004) # SWP_NOZORDER
        end
        @windowed_data[@windowed_data[10] = m, 5] = [x, y, w, h, @keep_aspect]
      end
      nil
    end
    
    def frozen?()     !!@freeze_bmp        and !@freeze_bmp.disposed?        end
    def transition?() !!@transition_sprite and !@transition_sprite.disposed? end
    alias zeus_fullscreen_freeze freeze unless method_defined?(:zeus_fullscreen_freeze)
    def freeze
      @transition_sprite.stop_transition if transition?
      @transition_sprite &&= @transition_sprite.dispose
      @freeze_bmp = snap_to_bitmap unless frozen?
      zeus_fullscreen_freeze
    end
    def snap_to_bitmap
      bmp     = Bitmap.new(width, height)
      info    = [40,width,height,1,32].pack('Ll2S2x24')
      hdc     = Zeus::DLL.User32.GetDC(hwnd)
      bmp_hdc = Zeus::DLL.Gdi32.CreateCompatibleDC(hdc)
      bmp_hbm = Zeus::DLL.Gdi32.CreateCompatibleBitmap(hdc, width, height)
      bmp_obj = Zeus::DLL.Gdi32.SelectObject(bmp_hdc, bmp_hbm)
      Zeus::DLL.Gdi32.BitBlt(bmp_hdc, 0, 0, width, height, hdc, 0, 0, 0x00CC_0020) # SRCCOPY
      Zeus::DLL.Gdi32.GetDIBits(bmp_hdc, bmp_hbm, 0, height, bmp.address, info, 0) # DIB_RGB_COLORS
      Zeus::DLL.Gdi32.SelectObject(bmp_hdc, bmp_obj)
      Zeus::DLL.Gdi32.DeleteObject(bmp_hbm)
      Zeus::DLL.Gdi32.DeleteDC(bmp_hdc)
      Zeus::DLL.User32.ReleaseDC(hwnd, hdc)
      bmp
    end if $xp
    alias zeus_fullscreen_transition transition unless method_defined?(:zeus_fullscreen_transition)
    def transition(duration = $vxace ? 10 : 8, filename='', vague=40, gradient='')
      if frozen? and (@d3d or filename.empty? or Zeus::DLL.Fullscreen.exist?(:Transition) or ($xp and @fullscreen || width > 640 || height > 480))
        async_transition(duration, filename, vague, gradient)
        frame_reset
        wait(duration)
      else
        @freeze_bmp &&= @freeze_bmp.dispose
        zeus_fullscreen_transition(duration, filename, vague)
      end
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def async_transition(duration = $vxace ? 10 : 8, filename='', vague=40, gradient='')
      if frozen? and duration > 0
        @transition_sprite = Sprite.new
        @transition_sprite.z = 0xFFFE
        @transition_sprite.bitmap = @freeze_bmp
        @transition_sprite.transition(duration, filename, vague, gradient)
        @freeze_bmp = nil
      else
        @freeze_bmp &&= @freeze_bmp.dispose
      end
      zeus_fullscreen_transition(0)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    
    def fadeout(duration) wait(duration) {self.brightness -= 255.0 / duration}; self.brightness =   0; nil
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end unless $xp
    def fadein(duration) wait(duration) {self.brightness += 255.0 / duration}; self.brightness = 255; nil
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end unless $xp
    def wait(duration) duration.times {|i| yield(i) if block_given?; Input.update; frame_reset; update}; nil
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    
  end
end

class Sprite
  @@vague = Hash.new {|h,k| h[k] = Array.new(256) {|i| Math.min(i*255/k, 255)}.pack('C*').freeze!}
  def transition?() !!@transition_data end
  def transition(duration = $vxace ? 10 : 8, filename='', vague=40, gradient='')
    return if @transition_data or !bitmap or bitmap.disposed?
    transition_bmp = Cache.load_bitmap('Graphics/Transitions/', File.basename(filename)) unless filename.empty? or !Zeus::DLL.Fullscreen.exist?(:Transition)
    transition_bmp = nil if transition_bmp and (transition_bmp.width < width or transition_bmp.height < height)
    if transition_bmp
      self.bitmap, self.src_rect = bitmap.dup, src_rect.dup if bitmap.cached?
      gradient_bmp = Cache.load_bitmap('Graphics/Transitions/', File.basename(gradient)) unless gradient.empty?
    end
    @transition_data = [0, duration, bitmap, transition_bmp, gradient_bmp, @@vague[Math.mid(1, vague, 255)]]
    nil
  rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
  end
  def stop_transition
    return unless @transition_data
    @transition_data[2].dispose unless @transition_data[2].disposed?
    self.bitmap = nil unless disposed? or bitmap != @transition_data[2]
    @transition_data = nil
  rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
  end
  alias zeus_transition_update update unless method_defined?(:zeus_transition_update)
  def update
    zeus_transition_update
    return unless @transition_data
    i, duration, bmp, transition_bmp, gradient_bmp, vague = @transition_data
    n = (@transition_data[0]+=1) * 255 / duration
    if i >= duration or disposed? or bitmap != bmp or bmp.disposed? or (transition_bmp and transition_bmp.disposed?) or (gradient_bmp and gradient_bmp.disposed?)
      stop_transition
    elsif !transition_bmp
      self.opacity = 255 - n
    elsif n != i * 255 / duration
      Zeus::DLL.Fullscreen.Transition(bmp, src_rect, transition_bmp, gradient_bmp || :nil, vague, n)
      bmp.data_update
    end
    nil
  rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
  end
end

Zeus::OS.dpi_awareness = 2 # PROCESS_PER_MONITOR_DPI_AWARE
Graphics.after_update &Graphics.method(:update_fullscreen)
Graphics.load_settings
Graphics.update_fullscreen