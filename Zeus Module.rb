=begin
  Zeus Module v1 for XP, VX and VXace by Zeus81
  
  Aliased methods:
    String::initialize_copy
    Bitmap::initialize_copy, ::font=
    Viewport::initialize
    Graphics::update
  only on xp and vx:
    Hash::[]
    Color::initialize, ::set
    Tone::initialize, ::set
    Rect::initialize, ::set
    Input::press?, ::trigger?, ::repeat?
  only on vxace:
    Object::rgss_main
    
  License:
    MIT (Free for commercial use)
  
  Self Promotion:
    Check out my game: https://store.steampowered.com/app/3817260/The_Myth_of_a_Godslayer/
=end

unless ($imported ||= {})[:Zeus_Module]
  $imported[:Zeus_Module] = 1

  $xp = $vx = $vxace = false
  RUBY_VERSION == '1.8.1' ? defined?(Hangup) ? $xp = true : $vx = true : $vxace = true
  $rgss = $xp ? :xp : $vx ? :vx : :vxace
  UNDEFINED = Object.new
  
unless $vxace
  
  module Kernel
    alias msgbox   print unless method_defined?(:msgbox)
    alias msgbox_p p     unless method_defined?(:msgbox_p)
    def define_singleton_method(method, &block)
      (class << self; self; end).__send__(:define_method, method, &block)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Object
    def tap() yield self; self end
  end
  
  class IO
    def self.binread(filename, length=nil, offset=0)
      open(filename, 'rb') {|f| f.seek(offset); f.read(length)}
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Integer
    def even?() self[0] == 0 end
    def odd?()  self[0] == 1 end
    def round(n=nil) super() end
  end
  
  class Float
    INFINITY = 1.0 / 0
    def round(n=nil) (n=10**n.to_i) > 1 ? (self * n).round / n.to_f : super()
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Symbol
    def to_proc() @proc ||= proc {|obj| obj.__send__(self)} end
  end
  
  class String
    alias getbyte  []   unless method_defined?(:getbyte)
    alias setbyte  []=  unless method_defined?(:setbyte)
    alias bytesize size unless method_defined?(:bytesize)
    def ord()              self[0]                                                              end
    def clear()            replace('')                                                          end
    def start_with?(*args) args.any? {|str| str.is_a?(String) and  index(str) == 0}             end
    def end_with?(*args)   args.any? {|str| str.is_a?(String) and rindex(str) == size-str.size} end
  end
  
  class Array
    def sort_by!
      replace(sort_by {|s| yield s})
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Hash
    class << self
      alias zeus_init []
      def [](*args)
        if args.size > 1
          h = {}; 0.step(args.size-1, 2) {|i| h[args[i]] = args[i+1]}; h
        elsif args[0].is_a?(Array)
          args.reduce({}) {|h,v| h[v[0]] = v[1]; h}
        else
          zeus_init(args[0])
        end
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
    end
    def flatten(level=1)
      (a=to_a).flatten!(level) or a
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  module Enumerable
    alias reduce inject unless method_defined?(:reduce)
    def count(obj=UNDEFINED)
      n = 0
      if obj != UNDEFINED
        each {|item| n += 1 if item == obj}
      elsif block_given?
        each {|item| n += 1 if yield item}
      else
        n = size
      end
      n
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def none?
      block_given? ? !any? {|s| yield s} : !any?
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def each_slice(n)
      ((size-1)/(n=n.to_i)+1).times {|i| yield self[i*n, n]}
      nil
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def find_index
      each_with_index {|x,i| return i if yield x}
      nil
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def min_by
      cache = Hash.new {|h,k| h[k] = yield k}
      min {|a,b| cache[a] <=> cache[b]}
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def max_by
      cache = Hash.new {|h,k| h[k] = yield k}
      max {|a,b| cache[a] <=> cache[b]}
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Color
    alias zeus_initialize initialize unless private_method_defined?(:zeus_initialize)
    def initialize(r=nil, g=nil, b=nil, a=255)
      r = g = b = a = 0 unless r
      zeus_initialize(r, g, b, a)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    alias zeus_set set unless method_defined?(:zeus_set)
    def set(r, g=nil, b=nil, a=255)
      (g=r.green; b=r.blue; a=r.alpha; r=r.red) unless g
      zeus_set(r, g, b, a)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Tone
    alias zeus_initialize initialize unless private_method_defined?(:zeus_initialize)
    def initialize(r=0, g=0, b=0, a=0)
      zeus_initialize(r, g, b, a)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    alias zeus_set set unless method_defined?(:zeus_set)
    def set(r, g=nil, b=nil, a=0)
      (g=r.green; b=r.blue; a=r.gray; r=r.red) unless g
      zeus_set(r, g, b, a)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Rect
    alias zeus_initialize initialize unless private_method_defined?(:zeus_initialize)
    def initialize(x=0, y=0, w=0, h=0)
      zeus_initialize(x, y, w, h)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    alias zeus_set set unless method_defined?(:zeus_set)
    def set(x, y=nil, w=nil, h=nil)
      (y=x.y; w=x.width; h=x.height; x=x.x) unless y
      zeus_set(x, y, w, h)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class << Input
    [:press?, :trigger?, :repeat?].each do |func| class_eval("
      alias zeus_#{func} #{func} unless method_defined?(:zeus_#{func})
      def #{func}(k)
        k = const_get(k) if k.is_a?(Symbol)
        zeus_#{func}(k)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
    ") end
  end
  
end
  
if $xp
  
  $TEST = $DEBUG
  Cache = RPG::Cache
  Game_Interpreter = Interpreter if defined? Interpreter
  
  module Sound
    def self.play_cursor() $game_system.se_play($data_system.cursor_se)   end
    def self.play_ok()     $game_system.se_play($data_system.decision_se) end
    def self.play_cancel() $game_system.se_play($data_system.cancel_se)   end
    def self.play_buzzer() $game_system.se_play($data_system.buzzer_se)   end
  end
  
  class Bitmap
    CLEAR_COLOR = Color.new
    def clear_rect(x, y=nil, w=nil, h=nil)
      (y=x.y; w=x.width; h=x.height; x=x.x) unless y
      fill_rect(x, y, w, h, CLEAR_COLOR)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Sprite
    def width()  src_rect.width  end
    def height() src_rect.height end
  end
  
  class << Graphics
    def width()  640 end unless method_defined?(:width)
    def height() 480 end unless method_defined?(:height)
    def wait(d)  d.times {update}
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
end

  module Math
    PIx2, PI_2, PI_4, PI_6, PI_8, PI_180 = PI*2, PI/2, PI/4, PI/6, PI/8, PI/180
  module_function
    def min(x, max)       x < max ? x : max
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def max(x, min)       x > min ? x : min
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def mid(min, x, max)  (x < max ? x : x=max) > min ? x : min
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def log2(x) log(x) / log(2)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def deg360(value)     (value / PI_180).to_i % 360
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def deg(value)        value / PI_180
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def rad(value)        value * PI_180
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def cos_deg(value)    cos(value * PI_180)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def sin_deg(value)    sin(value * PI_180)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def rad_delta(a, b)   (d = (a-b).abs%PIx2) > PI  ? PIx2-d : d
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def deg_delta(a, b)   (d = (a-b).abs%360 ) > 180 ?  360-d : d
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def hypot3d(x, y, z)  sqrt(x*x + y*y + z*z)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def triangular(n, base=1)     n*(n/base+1)/2
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def inv_triangular(n, base=1) (sqrt(8*n+1)-1)*sqrt(base)/2
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def wave_t(amp=1, speed=1, phase=0, count=Graphics.frame_count)
      i = (speed*count+phase-90) % 360
      amp * (i < 180 ? 90-i : i-270) / 90.0
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def wave_s(amp=1, speed=1, phase=0, count=Graphics.frame_count)
      amp * sin_deg(speed*count+phase)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def wave_c(amp=1, speed=1, phase=0, count=Graphics.frame_count)
      amp * cos_deg(speed*count+phase)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def easing(x, type=:inverse, exponent=2)
      return x if x == 0 or x == 1
      case type
      when :power   ; x ** exponent
      when :inverse ; x / (x + (1-x) * exponent)
      when :elastic ; 1 - cos(PI * x**2 * exponent) * (1-x)
      when :bounce  ; (x = easing(x, :elastic, exponent)) > 1 ? 2-x : x
      when :back    ; easing(x, :elastic, 1) ** exponent
      when :rpower  ; 1 - easing(1-x, :power  , exponent)
      when :rinverse; 1 - easing(1-x, :inverse, exponent)
      when :relastic; 1 - easing(1-x, :elastic, exponent)
      when :rbounce ; 1 - easing(1-x, :bounce , exponent)
      when :rback   ; 1 - easing(1-x, :back   , exponent)
      when Hash
        type.each do |r,t|
          next unless r.include?(x)
          e = exponent.is_a?(Hash) ? exponent[r] : exponent
          return easing((x-r.begin)/(r.end-r.begin), t, e)*(r.end-r.begin) + r.begin
        end
        x
      when Array
        type.each_with_index do |t,i|
          e = exponent.is_a?(Array) ? exponent[i] : exponent
          x = easing(x, t, e)
        end
        x
      else x
      end
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end

  module Kernel
    @@cache_eval = Hash.new {|h,k| h[k] = eval("proc{#{k}\n}")}
    def cache_eval(s)
      instance_eval(&@@cache_eval[s])
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end

  class FalseClass
    def to_i()  0    end
    def to_f()  0.0  end
    def bool?() true end
  end

  class TrueClass
    def to_i()  1    end
    def to_f()  1.0  end
    def bool?() true end
  end

  class Object
    def to_b() !!self end
    def bool?() false end
    alias deep_dup    dup
    alias deep_freeze freeze
    def marshal_dup() Marshal.load(Marshal.dump(self))
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end

  [NilClass, FalseClass, TrueClass, Symbol, Numeric, Method].each do |klass|
    klass.class_eval do
      def dup() self end
      alias deep_dup dup
    end
  end
  
  module Enumerable
    def min_value(&block) o = min_by {|o| yield o} and yield o
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def max_value(&block) o = max_by {|o| yield o} and yield o
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Hash
    def deep_dup() h = {}; each {|k,v| h[k.deep_dup] = v.deep_dup}; h
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def deep_freeze() each {|k,v| k.deep_freeze; v.deep_freeze}.freeze
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end

  class Array
    def deep_dup() map {|o| o.deep_dup}
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def deep_freeze() each {|o| o.deep_freeze}.freeze
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def delete_first(i) i=index(i)  and delete_at(i) end
    def delete_last(i)  i=rindex(i) and delete_at(i) end
  end

  class IO
    def self.write(filename, data, offset=nil)
      open(filename, offset ? 'r+' : 'w') {|f| f.seek(offset.to_i); f.write(data)}
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def self.binwrite(filename, data, offset=nil)
      open(filename, offset ? 'rb+' : 'wb') {|f| f.seek(offset.to_i); f.write(data)}
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end

  class Range
    def clamp(v)
      return v unless first.is_a?(Numeric) and last.is_a?(Numeric) and v.is_a?(Numeric)
      Math.mid(first, v,  last - (exclude_end? ? last.is_a?(Float) ? 1.0/10**last.decimals : 1 : 0))
    end
    def loop(v)
      return v unless first.is_a?(Numeric) and last.is_a?(Numeric) and v.is_a?(Numeric)
      (v-first) % size + first
    end
    def size
      return unless first.is_a?(Numeric) and last.is_a?(Numeric)
      last + (exclude_end? ? 0 : last.is_a?(Float) ? 1.0/10**last.decimals : 1) - first
    end
    def sample
      return unless s = size
      first + (s.is_a?(Float) ? rand*s : rand(s))
    end
  end
  
  class Numeric
    def get_bit(i)   self[i] == 1                                                    end
    def set_bit(i,v) v && v != 0 ? self | (1<<i) : self & ~(1<<i)                    end
    def abs_floor()  self <  0 ? ceil  : floor                                       end
    def abs_ceil()   self <  0 ? floor : ceil                                        end
    def sign(zero=0) self <= 0 ? self < 0 ? -1 : zero : 1                            end
    def to_b()       self != 0                                                       end
    def to_c_float() [self].pack('f').unpack('L')[0]                                 end
    def decimals()   i=-1; return i if (n=self*10**i) == n.to_i while (i+=1) < 15; i end
  end
  
  Fixnum::MIN = -0x4000_0000
  Fixnum::MAX =  0x3FFF_FFFF
  
  class Symbol
    def +(s) :"#{self}#{s}" end
  end

  class String
    alias zeus_initialize_copy initialize_copy unless private_method_defined?(:zeus_initialize_copy)
    def initialize_copy(o)
      zeus_initialize_copy(o)
      @address = nil
    end
    def freeze!()   @address = address unless frozen?; freeze   end
    def address()   @address or [self].pack('p').unpack('L')[0] end
    def >>(str)     str.insert(0, self)                         end
    def to_utf8()   Zeus::Encode.encode( self, :UTF16, :UTF8 )  end
    def to_utf8!()  Zeus::Encode.encode!(self, :UTF16, :UTF8 )  end
    def to_utf16()  Zeus::Encode.encode( self, :UTF8 , :UTF16)  end
    def to_utf16!() Zeus::Encode.encode!(self, :UTF8 , :UTF16)  end
    def to_b()      !!(self =~ /true/i) or to_i != 0            end
    def numeric?()  !!(self =~ /^-?\d/)                         end
  end

  class Viewport
    @@instances = []
    def self.instances() @@instances.delete_if {|v| v.disposed?} end
    alias zeus_initialize initialize unless private_method_defined?(:zeus_initialize)
    def initialize(x=nil, y=nil, w=nil, h=nil)
      (x=0; y=0; w=Graphics.width; h=Graphics.height) unless x
      (y=x.y; w=x.width; h=x.height; x=x.x) unless y
      @@instances << zeus_initialize(x, y, w, h)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def disposed?() !z rescue true end
  end
  
  class Sprite
    alias zoom zoom_x
    def zoom=(i) self.zoom_x = self.zoom_y = i end
    def resize_bitmap(w, h, copy=false)
      self.bitmap = bitmap ? bitmap.resize(w, h, copy) : Bitmap.new(Math.max(1,w), Math.max(1,h))
      src_rect.set(0, 0, w, h)
      bitmap
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Plane
    alias zoom zoom_x
    def zoom=(i) self.zoom_x = self.zoom_y = i end
  end
  
  module ColorConvert
    def set_hcm(h, c, m)
      c = Math.mid(0, c, 255)
      m = Math.mid(0, m, 255)
      x = c * (1 - ((h/=60.0)%2 - 1).abs)
      case h.to_i % 6
      when 0; set(c+m, x+m,   m)
      when 1; set(x+m, c+m,   m)
      when 2; set(  m, c+m, x+m)
      when 3; set(  m, x+m, c+m)
      when 4; set(x+m,   m, c+m)
      when 5; set(c+m,   m, x+m)
      end
    end
    def hue()
      case v=max
      when m=min; 0.0
      when red  ; (60.0 * (green-blue) / (v-m)      ) % 360
      when green; (60.0 * (blue-red  ) / (v-m) + 120) % 360
      when blue ; (60.0 * (red-green ) / (v-m) + 240) % 360
      end
    end
    def hue=(h)          set_hcm(h, chroma, min)                                       end
    def chroma()         max-min                                                       end
    def chroma=(c)       set_hcm(hue, c, min)                                          end
    def min()            red<green ? red<blue ? red : blue : green<blue ? green : blue end
    def min=(m)          set_hcm(hue, chroma, m)                                       end
      
    def set_hsl(h, s, l) set_hcm(h, c=s*(1-(l/127.5-1).abs), l-c/2)                    end
    def saturation_l()   (c=chroma)==0 ? 0.0 : c/(1-(lightness/127.5-1).abs)           end; alias saturation  saturation_l
    def saturation_l=(s) set_hsl(hue, s, lightness)                                    end; alias saturation= saturation_l=
    def lightness()      (max+min)/2.0                                                 end
    def lightness=(l)    set_hsl(hue, saturation_l, l)                                 end
    
    def set_hsv(h, s, v) set_hcm(h, c=v*s/255.0, v-c)                                  end
    def saturation_v()   (v=value)==0 ? 0.0 : (v-min)*255.0/v                          end
    def saturation_v=(s) set_hsv(hue, s, value)                                        end
    def value()          red>green ? red>blue ? red : blue : green>blue ? green : blue end; alias max  value
    def value=(v)        set_hsv(hue, saturation_v, v)                                 end; alias max= value=
    
    def set_hsi(h, s, i) set_hcm(h, i*s/(85*(2-(h/60.0%2-1).abs)), i*(255-s)/255.0)    end
    def saturation_i()   (i=intensity)==0 ? 0.0 : 255 - min*255/i                      end
    def saturation_i=(s) set_hsi(hue, s, intensity)                                    end
    def intensity()      (red+green+blue)/3.0                                          end
    def intensity=(i)    set_hsi(hue, saturation_i, i)                                 end
    
    def luma(rec=709)
      case rec
      when  601; red*0.2989 + green*0.5866 + blue*0.1145
      when  709; red*0.2126 + green*0.7152 + blue*0.0722
      when 2020; red*0.2627 + green*0.6780 + blue*0.0593
      end
    end
  end

  class Color
    include ColorConvert
    def to_int() __id__<<1                 end
    def to_a()   [red, green, blue, alpha] end
    def hash()   to_a.hash                 end
    def clear()  set(0, 0, 0, 0)           end
    def blt(r, g=nil, b=nil, a=255)
      (a = r.alpha; b = r.blue; g = r.green; r = r.red) unless b
      return self                 if a == 0
      return set(r, g, b, a) if a == 255 or alpha == 0
      a2 = a + a1 = alpha * (255 - a) / 255
      set((red   * a1 + r * a) / a2,
          (green * a1 + g * a) / a2,
          (blue  * a1 + b * a) / a2, a2)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end
  
  class Tone
    include ColorConvert
    def to_int() __id__<<1                 end
    def to_a()   [red, green, blue, gray]  end
    def hash()   to_a.hash                 end
    def clear()  set(0, 0, 0, 0)           end
    def add(r, g=nil, b=nil, a=0)
      (a = r.gray; b = r.blue; g = r.green; r = r.red) unless b
      set(red + r, green + g, blue + b, gray + a)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
  end

  class Table
    def to_int() __id__<<1                 end
  end

  class Rect
    def x2()     x+width                   end
    def y2()     y+height                  end
    def to_int() __id__<<1                 end
    def to_a()   [x, y, width, height]     end
    alias clear empty
  end

  RectF = Struct.new(:x, :y, :width, :height) unless defined? RectF
  class RectF
    def initialize(x=0.0, y=0.0, w=0.0, h=0.0)
      super
    end
    def set(x, y=nil, w=nil, h=nil)
      (y=x.y; w=x.width; h=x.height; x=x.x) unless y
      self.x=x; self.y=y; self.width=w; self.height=h
      self
    end
    def x2()    x+width                   end
    def y2()    y+height                  end
    def empty() set(0.0, 0.0, 0.0, 0.0)   end
    alias clear empty
  end

  class Font
   (def self.default_shadow()       @@default_shadow       end; def self.default_shadow=(b)       @@default_shadow       = b end; @@default_shadow       = false                  ) if $xp
   (def self.default_outline()      @@default_outline      end; def self.default_outline=(b)      @@default_outline      = b end; @@default_outline      = false                  ) unless $vxace
   (def self.default_out_color()    @@default_out_color    end; def self.default_out_color=(c)    @@default_out_color    = c end; @@default_out_color    = Color.new(0, 0, 0, 128)) unless $vxace
    def self.default_shear()        @@default_shear        end; def self.default_shear=(i)        @@default_shear        = i end; @@default_shear        = 0
    def self.default_spacing()      @@default_spacing      end; def self.default_spacing=(i)      @@default_spacing      = i end; @@default_spacing      = 0
    def self.default_line_spacing() @@default_line_spacing end; def self.default_line_spacing=(i) @@default_line_spacing = i end; @@default_line_spacing = 0
   (def shadow()           defined?(@shadow)       ? @shadow       : @shadow       = @@default_shadow       end; attr_writer :shadow   ) if $xp
   (def outline()          defined?(@outline)      ? @outline      : @outline      = @@default_outline      end; attr_writer :outline  ) unless $vxace
   (def out_color()        defined?(@out_color)    ? @out_color    : @out_color    = @@default_out_color    end; attr_writer :out_color) unless $vxace
    def shear()            return 0 if !$imported[:Zeus_GDIP] or Zeus::OS.proton_version == 9
                           defined?(@shear)        ? @shear        : @shear        = @@default_shear        end; attr_writer :shear
    def spacing()          defined?(@spacing)      ? @spacing      : @spacing      = @@default_spacing      end; attr_writer :spacing
    def line_spacing()     defined?(@line_spacing) ? @line_spacing : @line_spacing = @@default_line_spacing end; attr_writer :line_spacing
    def hash()             [active_name, size, bold, italic, color.red.to_i, color.green.to_i, color.blue.to_i, color.alpha.to_i, shadow, outline,
                            out_color.red.to_i, out_color.green.to_i, out_color.blue.to_i, out_color.alpha.to_i, shear, spacing, line_spacing].hash end
    def active_name()      name.is_a?(Array) ? name.find {|n| Font.exist?(n)} || name[0] : name                                                     end
    def marshal_dump()     [name, size, bold, italic, color, shadow, outline, out_color, shear, spacing, line_spacing]                              end
    def marshal_load(dump) initialize; self.name, self.size, self.bold, self.italic, self.color, self.shadow, self.outline, self.out_color, self.shear, self.spacing, self.line_spacing = dump
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def ==(f)
      self.class == f.class and active_name == f.active_name and size == f.size  and bold == f.bold and italic == f.italic and color == f.color and
      shadow == f.shadow and outline == f.outline and out_color == f.out_color and shear == f.shear and spacing == f.spacing  and line_spacing == f.line_spacing
    end; alias eql? :==
    def z_text_size(text, tags=true)
      bmp = Bitmap::Z_CACHE[:bmp] = Bitmap::Z_CACHE[:bmp].resize(1, 1)
      bmp.font = self
      bmp.z_text_size(text, tags)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def z_text_rect(text, font_hash=nil)
      bmp = Bitmap::Z_CACHE[:bmp] = Bitmap::Z_CACHE[:bmp].resize(1, 1)
      bmp.font = self
      bmp.z_text_rect(text, font_hash)
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    OFFSETS = Hash.new {|h,k| h[k] = Hash.new([0,0,0,0])}
    def ox_l(c=nil) 4 + shear.abs.to_i + (italic ?      3 : 0) + (outline           ? 1 : 0) + (c ? (OFFSETS[active_name][c][italic ? 2 : 0]*size+50)/100 : 0) end
    def ox_r(c=nil) 2 + shear.abs.to_i + (italic ? size/6 : 0) + (outline || shadow ? 1 : 0) + (c ? (OFFSETS[active_name][c][italic ? 3 : 1]*size+50)/100 : 0) end
  end
  
  class Bitmap
    alias zeus_initialize_copy initialize_copy unless private_method_defined?(:zeus_initialize_copy)
    def initialize_copy(o)
      zeus_initialize_copy(o)
      @address = nil
    end
    alias zeus_font= font= unless method_defined?(:zeus_font=)
    def font=(f)
      return if disposed?
      self.zeus_font    = f
      font.shadow       = f.shadow    if $xp
      font.outline      = f.outline   unless $vxace
      font.out_color    = f.out_color unless $vxace
      font.shear        = f.shear
      font.spacing      = f.spacing
      font.line_spacing = f.line_spacing
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def resize(w, h, copy=false)
      if disposed?
        Bitmap.new(Math.max(1,w), Math.max(1,h))
      elsif width >= w and height >= h
        clear unless copy
        self
      else
        bmp = Bitmap.new(Math.max(width, w), Math.max(height, h))
        bmp.font = font
        bmp.blt(0, 0, self, rect) if copy
        dispose
        bmp
      end
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    Z_ESCAPE_CHAR = '$'
    Z_CACHE = {}
    Z_CACHE[:buf]  = Bitmap.new(1, 1)
    Z_CACHE[:bmp]  = Bitmap.new(1, 1)
    Z_CACHE[:data] = Hash.new {|h,k| h[k] = {}}
    Z_CACHE[:x] = Z_CACHE[:y] = Z_CACHE[:w] = 0
    Z_CACHE[:font] = {}
    Z_CACHE[:rect] = Z_CACHE[:lines] = nil
    alias zeus_draw_text draw_text unless method_defined?(:zeus_draw_text)
    def z_draw_text(x, y=nil, w=nil, h=nil, text=nil, options=nil)
      return if disposed?
      case x
      when Integer
      when Rect; text=y; options=w; y=x.y; w=x.width; h=x.height; x=x.x
      else       text=x; options=y; x=y=0; w=width  ; h=height
      end
      options   = options.is_a?(Integer) ? {:align=>options} : options || {}
      opacity   = options.fetch(:opacity, 255)
      align     = options.fetch(:align, 0)
      tags      = options.fetch(:tags, true)
      clear     = options.fetch(:clear, false)
      stretch_x = options.fetch(:stretch_x, true)
      stretch_y = options.fetch(:stretch_y, false)
      lines     = Z_CACHE[:lines] ||= []
      rect      = Z_CACHE[:rect]  ||= z_text_size(text, tags)
      tw        = stretch_x ? rect.width  : Math.min(w, rect.width)
      th        = stretch_y ? rect.height : Math.min(h, rect.height)
      clear_rect(x, y, w, h) if clear
      if (tw>w or th>h) and tw*th>0
        bmp = Z_CACHE[:bmp] = Z_CACHE[:bmp].resize(tw, th)
        bmp.font = font
        bmp.z_draw_text(0, 0, tw, th, text, options)
        dest_rect = Rect.new(tw>w ? x : x+(w-tw)*(align%3)/2, th>h ? y : y+(h-th)*((align+3)/3%3)/2, Math.min(w, tw), Math.min(h, th))
        if $imported[:Zeus_GDIP]
          stretch_blt2(dest_rect, bmp, Rect.new(0, 0, tw, th)) do
            @interpolation = :Bicubic
            @pixel_offset  = :None
            @compositing   = :SourceOver
          end
          gdip.dispose
        else
          stretch_blt(dest_rect, bmp, Rect.new(0, 0, tw, th))
        end
        return
      end
      x0 = x+(w-rect.width)*(align%3)/2
      cy = y+(h-rect.height)*((align+3)/3%3)/2 + lines[l=0][1]
      cx = lines.size > 1 && cy < y ? nil : x0+(rect.width-lines[l][0])*(align%3)/2
      ox = oy = 0
      text = text.is_a?(String) ? text.dup : text.to_s
      font_hash = nil
      while c = text.slice!(/./m)
        if c == "\n"
          break if cy > y+h
          cx = (cy += lines[l+=1][1]) < y ? nil : x0+(rect.width-lines[l][0])*(align%3)/2
          ox = oy = 0
          next
        elsif tags and c == Z_ESCAPE_CHAR and r = z_text_tags(text)
          case r.is_a?(Array) ? r[0] : r
          when 'X' ; cx = r[1]+x; ox = 0; next
          when 'Y' ; oy = r[1]          ; next
          when Font; font_hash = nil    ; next
          when Rect; printable_char = false; b = Cache.system('IconSet')
          end
        elsif cx
          r = z_text_rect(c, font_hash ||= font.hash)
          b = Z_CACHE[:buf]
          ox += font.ox_l(c) if printable_char = r.width != 0 && c != ' '
        end
        if   !cx or x > cx += r.width - ox
        elsif cx-r.width > x+w
          lines.size-1 == l ? break : cx = nil
        elsif printable_char or b == Cache.system('IconSet')
          _x = cx-r.width; _y = cy+oy-r.height
          if !stretch_x and (cx-r.width  < x or cx > x+w)
            r = r.dup if r.frozen?
            _x -= r.x - r.x += r.width  - r.width  = cx-x if cx-r.width  < x
            r.width  -= cx-x-w if cx > x+w
          end
          if !stretch_y and (cy-r.height < y or cy > y+h)
            r = r.dup if r.frozen?
            _y -= r.y - r.y += r.height - r.height = cy-y if cy-r.height < y
            r.height -= cy-y-h if cy > y+h
          end
          blt(_x, _y, b, r, opacity)
        end
        ox = printable_char ? font.ox_r(c) - font.spacing : 0
      end
      Z_CACHE[:font].each {|k,v| font.send(k, v)}.clear
      Z_CACHE[:rect] = Z_CACHE[:lines] = nil
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def z_text_tags(text)
      return if text.slice!(/\A#{Z_ESCAPE_CHAR}/) or !(text.slice!(/\A(B|I|D|O)/i) or text.slice!(/\A(F|S|SH|CS|LS|C|OC|J|X|Y)\((.+?)\)/i))
      case tag = $1.upcase! || $1
      when 'B'    ; Z_CACHE[:font][:bold=]         = font.bold          unless Z_CACHE[:font].key?(:bold=)        ; font.bold        ^= true                            ; font
      when 'I'    ; Z_CACHE[:font][:italic=]       = font.italic        unless Z_CACHE[:font].key?(:italic=)      ; font.italic      ^= true                            ; font
      when 'D'    ; Z_CACHE[:font][:shadow=]       = font.shadow        unless Z_CACHE[:font].key?(:shadow=)      ; font.shadow      ^= true                            ; font
      when 'O'    ; Z_CACHE[:font][:outline=]      = font.outline       unless Z_CACHE[:font].key?(:outline=)     ; font.outline     ^= true                            ; font
      when 'F'    ; Z_CACHE[:font][:name=]         = font.name          unless Z_CACHE[:font].key?(:name=)        ; font.name         = $2                              ; font
      when 'S'    ; Z_CACHE[:font][:size=]         = font.size          unless Z_CACHE[:font].key?(:size=)        ; font.size         = Math.mid(6,$2.to_i,96)          ; font
      when 'SH'   ; Z_CACHE[:font][:shear=]        = font.shear         unless Z_CACHE[:font].key?(:shear=)       ; font.shear        = $2.to_f                         ; font
      when 'CS'   ; Z_CACHE[:font][:spacing=]      = font.spacing       unless Z_CACHE[:font].key?(:spacing=)     ; font.spacing      = $2.to_i                         ; font
      when 'LS'   ; Z_CACHE[:font][:line_spacing=] = font.line_spacing  unless Z_CACHE[:font].key?(:line_spacing=); font.line_spacing = $2.to_i                         ; font
      when 'C'    ; Z_CACHE[:font][:color=]        = font.color.dup     unless Z_CACHE[:font].key?(:color=)       ; font.color.set(*$2.split(',').map! {|s| s.to_i})    ; font
      when 'OC'   ; Z_CACHE[:font][:out_color=]    = font.out_color.dup unless Z_CACHE[:font].key?(:out_color=)   ; font.out_color.set(*$2.split(',').map! {|s| s.to_i}); font
      when 'J'    ; Rect.new($2.to_i%16*24, $2.to_i/16*24, 24, 24)
      when 'X','Y'; [tag, $2.to_i]
      end
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    alias zeus_text_size text_size unless method_defined?(:zeus_text_size)
    def z_text_size(text, tags=true)
      return if disposed?
      rect = Rect.new
      line_w = line_h = ox = oy = 0
      font_hash = printable_char = nil
      text = text.is_a?(String) ? text.dup : text.to_s
      while true
        if !c = text.slice!(/./m) or c == "\n"
          line_w      -= ox + font.spacing if printable_char
          line_h       = font.size if c and line_h == 0
          line_h      += font.line_spacing if rect.height != 0
          rect.width   = Math.max(rect.width, line_w)
          rect.height +=  line_h
          Z_CACHE[:lines] << [line_w, line_h] if Z_CACHE[:lines]
          line_w = line_h = ox = oy = 0
          printable_char = false
          c ? next : break
        elsif tags and c == Z_ESCAPE_CHAR and r = z_text_tags(text)
          case r.is_a?(Array) ? r[0] : r
          when 'X' ; line_w = r[1]; ox = 0; next
          when 'Y' ; oy = r[1]            ; next
          when Font; font_hash = nil      ; next
          when Rect; printable_char = false
          end
        else
          r = z_text_rect(c, font_hash ||= font.hash)
          ox += font.ox_l(c) if printable_char = r.width != 0 && c != ' '
        end
        line_w += r.width - ox
        line_h = Math.max(line_h, r.height)
        ox = printable_char ? font.ox_r(c) - font.spacing : 0
      end
      Z_CACHE[:font].each {|k,v| font.send(k, v)}.clear
      rect
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def z_text_rect(text, font_hash=nil)
      return if disposed?
      if Z_CACHE[:buf].disposed?
        Z_CACHE[:data].clear
        Z_CACHE[:x] = Z_CACHE[:y] = Z_CACHE[:w] = 0
      end
      rect = Z_CACHE[:data][font_hash ||= font.hash][text = (text.is_a?(String) ? text.dup : text.to_s).freeze]
      return rect if rect
      rect = zeus_text_size(text)
      return Z_CACHE[:data][font_hash][text] = rect.freeze if rect.width == 0 or text == ' '
      bmp  = Z_CACHE[:buf] = Z_CACHE[:buf].resize(100, 10_000, true)
      rect.set(Z_CACHE[:x], Z_CACHE[:y], rect.width+font.ox_l+font.ox_r, font.size+(font.outline ? 2 : font.shadow ? 1 : 0))
      (rect.x = Z_CACHE[:x] += Z_CACHE[:w]; rect.y = Z_CACHE[:y] = Z_CACHE[:w] = 0) if rect.y2 > bmp.height
      bmp  = Z_CACHE[:buf] = Z_CACHE[:buf].resize(bmp.width+100, bmp.height, true)  if rect.x2 > bmp.width
      Z_CACHE[:data][font_hash][text] = rect.freeze
      Z_CACHE[:w]  = rect.width if rect.width > Z_CACHE[:w]
      Z_CACHE[:y] += rect.height
      if (shear=font.shear) != 0
        font.shear = 0
        shear_rect = z_text_rect(text)
        font.shear = shear
        bmp.interpolation = :Bicubic
        bmp.compositing   = :SourceCopy
        bmp.shear_blt(rect.x, rect.y, shear*rect.height/-10.0, 0, bmp, shear_rect)
        return rect
      end
      bmp.font.name   = font.name
      bmp.font.size   = font.size
      bmp.font.bold   = font.bold
      bmp.font.italic = font.italic
      x = rect.x + font.ox_l - z_text_rect(' ', font_hash).width
      y = rect.y + (font.outline ? 1 : 0)
      w = rect.width + 100
      h = font.size
      text = " #{text} "
      if $vxace
        bmp.font.outline = font.outline
        bmp.font.out_color.set(font.out_color)
      elsif font.outline
        bmp.font.color.set(font.out_color)
        bmp.font.color.alpha *= font.color.alpha / 255.0
        bmp.zeus_draw_text(x-1, y-1, w, h, text)
        bmp.zeus_draw_text(x+1, y-1, w, h, text)
        bmp.zeus_draw_text(x-1, y+1, w, h, text)
        bmp.zeus_draw_text(x+1, y+1, w, h, text)
      end
      if !$xp
        bmp.font.shadow = font.shadow
      elsif font.shadow
        bmp.font.color.set(0, 0, 0, font.color.alpha)
        bmp.zeus_draw_text(x+1, y+1, w, h, text)
      end
      bmp.font.color.set(font.color)
      bmp.zeus_draw_text(x, y, w, h, text)
      rect
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def fill_ellipse(x, y, w=nil, h=nil, color=y)
      return if disposed?
      (y=x.y; w=x.width; h=x.height; x=x.x) unless w
      r  = w * h / 4.0
      x += ox = w/=2
      y += h/=2
      oy = 0
      while oy < h
        oy += 1
        ox -= 1 while ox > 0 and Math.hypot(ox*h, oy*w) > r
        fill_rect(x-ox, y-oy  , ox*2, 1, color)
        fill_rect(x-ox, y+oy-1, ox*2, 1, color)
      end
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def to_int() __id__<<1 end
    def address
      @address ||= (
        Zeus::DLL.Kernel32.RtlMoveMemory§read(buf=[].pack('x4'), to_int+16, 4)
        Zeus::DLL.Kernel32.RtlMoveMemory§read(buf, buf.unpack('L')[0]+8 , 4)
        Zeus::DLL.Kernel32.RtlMoveMemory§read(buf, buf.unpack('L')[0]+16, 4)
        buf.unpack('L')[0]
      )
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def bytesize() @bytesize ||= width * height * 4 end
    def data
      Zeus::DLL.Kernel32.RtlMoveMemory§read(data=[].pack("x#{bytesize}"), address, bytesize)
      data
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def data=(data)
      Zeus::DLL.Kernel32.RtlMoveMemory§write(address, data, bytesize)
      data_update
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def data_update() clear_rect(0, 0, 0, 0) end
    def data_ptr
      ptr = [].pack('x'); original_struct = [].pack('x12')
      ptr.define_singleton_method(:free) {Zeus::DLL.Kernel32.RtlMoveMemory§write(__id__*2+8, original_struct, 12)}
      def ptr.address() @address ||= super end
      def ptr.[](i, size=nil)
        if size
        then Zeus::DLL.Kernel32.RtlMoveMemory§read(str=[].pack("x#{size}"), address+i, size); str
        else getbyte(i)
        end
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def ptr.[]=(i, size, str=nil)
        if str
        then Zeus::DLL.Kernel32.RtlMoveMemory§write(address+i, str, size)
        else setbyte(i, size)
        end
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      Zeus::DLL.Kernel32.RtlMoveMemory§read(original_struct, ptr.__id__*2+8, 12)
      Zeus::DLL.Kernel32.RtlMoveMemory§write(ptr.__id__*2+8, [bytesize,address,bytesize].pack('L3'), 12)
      return ptr unless block_given?
      begin
        yield ptr
      ensure
        ptr.free
        data_update
      end
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def marshal_dump
      [width, height, font, data_ptr {|d| Zlib::Deflate.deflate(d, 9)}]
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def marshal_load(dump)
      initialize(dump[0], dump[1])
      self.font = dump[2]
      self.data = dump[3].replace(Zlib::Inflate.inflate(dump[3]))
      dump[3].clear
    rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
    end
    def cached?() Cache.cached?(self) end
  end

  def Cache.cached?(bmp) @cache.value?(bmp) end

  module Zeus
    module Cipher
      def self.cipher!(str, compress=0, key=$ENCRYPTION_KEY, limit=$ENCRYPTION_LIMIT)
        str.replace(Zlib::Deflate.deflate(str, compress-1)) if compress > 0
        if key
          i = -1; i_max = Math.min(limit || Fixnum::MAX, str.bytesize); key_size = key.size
          str.setbyte(i, str.getbyte(i) ^ key[i%key_size]) while (i+=1) < i_max
        end
        str.replace(Zlib::Inflate.inflate(str)) if compress < 0
        str
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.cipher(str, compress=0, key=$ENCRYPTION_KEY, limit=$ENCRYPTION_LIMIT)
        cipher!(str.dup, compress, key, limit)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.save!(str, filename, compress=true, key=$ENCRYPTION_KEY, limit=$ENCRYPTION_LIMIT)
        File.binwrite(filename, cipher!(str, compress ? 10 : 0, key, limit))
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.save(str, filename, compress=true, key=$ENCRYPTION_KEY, limit=$ENCRYPTION_LIMIT)
        save!(str.dup, filename, compress, key, limit)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.save_data(data, filename, compress=true, key=$ENCRYPTION_KEY, limit=$ENCRYPTION_LIMIT)
        save!(Marshal.dump(data), filename, compress, key, limit)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.load(filename, compress=true, key=$ENCRYPTION_KEY, limit=$ENCRYPTION_LIMIT)
        cipher!(File.binread(Dir["#{filename}.*"][0] || filename), compress ? -1 : 0, key, limit)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.load_data(filename, compress=true, key=$ENCRYPTION_KEY, limit=$ENCRYPTION_LIMIT)
        Marshal.load(load(filename, compress, key, limit))
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
    end
    class DLL
      def initialize(dll)
        if $vxace
          begin
            @dll = DL.dlopen(dll.to_s)
          rescue Exception
            @dll = nil
          end
        else @dll = dll
        end
        @api = Hash.new do |h,api_name|
          begin
            function, types = api_name.to_s.split('§', 2)
            if $vxace
              api = function ? DL::CFunc.new(@dll[function], DL::TYPE_LONG) : !!@dll
            elsif function
              api = Win32API.new(@dll.to_s, function, types, 'i')
            else
              api = (Win32API.new(@dll.to_s, '', '', '') rescue $!.message.start_with?('GetProcAddress'))
            end
          rescue Exception
            api = nil
          end
          h[api_name] = api
        end
      end
      def exist?(api_name=nil) !!@api[api_name] end
      def method_missing(method_name, *args)
        api_name = method_name.to_s[/\w+/]
        api_name << '§' unless args.empty?
        args_names   = ''
        args_convert = ''
        args.each_with_index do |v,id|
          args_names   << "#{', ' if id > 0}v#{id}"
          args_convert << ', ' if id > 0
          case v
          when TrueClass, FalseClass; args_convert << "v#{id} ? 1 : 0"
          when Float                ; args_convert << "v#{id}.to_c_float"
          when Fixnum               ; args_convert << "v#{id}"
          when String   , NilClass  ; args_convert << ($vxace ? "v#{id} ? v#{id}.address : 0" : "v#{id}.frozen? ? v#{id}.address : v#{id}")
          else                        args_convert << "v#{id}.is_a?(Symbol) ? 0 : v#{id}"
          end
          case v
          when String, NilClass; api_name << 'p'
          else                   api_name << 'i'
          end
        end
        args_convert = "[#{args_convert}]" if $vxace
        instance_eval("
        @#{api_name} = @api[:#{api_name}]
        def #{method_name}(#{args_names})
          @#{api_name}.call(#{args_convert})#{' != 0' if method_name.to_s.end_with?('?')}
        rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
        end")
        __send__(method_name, *args)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.method_missing(dll)
        instance_eval("
        class << self; attr_reader :#{dll} end
        @#{dll} = new(:#{dll})")
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
    end
    module Encode
      CodePages = {
        :ANSI=>0, :OEM=>1, :MAC=>2, :THREAD_ANSI=>3, :SYMBOL=>42,
        :WINDOWS874=>874, :SHIFT_JIS=>932, :BIG5=>950, :WINDOWS1250=>1250,
        :WINDOWS1251=>1251, :WINDOWS1252=>1252, :WINDOWS1253=>1253,
        :WINDOWS1254=>1254, :WINDOWS1255=>1255, :WINDOWS1256=>1256,
        :WINDOWS1257=>1257, :WINDOWS1258=>1258, :US_ASCII=>20127,
        :ISO8859_1=>28591, :ISO8859_2=>28592, :ISO8859_3=>28593,
        :ISO8859_4=>28594, :ISO8859_5=>28595, :ISO8859_6=>28596,
        :ISO8859_7=>28597, :ISO8859_8=>28598, :ISO8859_9=>28599,
        :ISO8859_13=>28603, :ISO8859_15=>28605, :ISO8859_8I=>38598,
        :ISO2022_JP=>50220, :ISO2022_KR=>50225, :ISO2022_CN=>50227,
        :EUC_JP=>51932, :EUC_CN=>51936, :EUC_KR=>51949, :GB2312=>52936,
        :UTF7=>65000, :UTF8=>65001, :UTF16=>-1
      }
      def self.encode(str, from, to, dchar=nil, dflag=nil)
        if (from = CodePages[from]) != -1
          l = DLL.Kernel32.MultiByteToWideChar(from, 0, str, str.bytesize, nil, 0)
          DLL.Kernel32.MultiByteToWideChar(from, 0, str, str.bytesize, utf16=[].pack("x#{l*2}"), l)
        else utf16 = str
        end
        if (to = CodePages[to]) != -1
          l = DLL.Kernel32.WideCharToMultiByte(to, 0, utf16, utf16.bytesize/2, nil, 0, dchar, dflag)
          DLL.Kernel32.WideCharToMultiByte(to, 0, utf16, utf16.bytesize/2, str=[].pack("x#{l}"), l, dchar, dflag)
        else str = utf16
        end
        case to
        when 20127; str.force_encoding('US-ASCII')
        when 65001; str.force_encoding('UTF-8')
        when    -1; str.force_encoding('UTF-16LE')
        end if $vxace
        str
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.encode!(str, from, to, dchar=nil, dflag=nil)
        str.replace(encode(str, from, to, dchar, dflag))
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.method_missing(method, str, dchar=nil, dflag=nil)
        _, from, to, mark = */(?:(\w+)_)?to_(\w+)(!)?/i.match(method.to_s)
        to &&= to.upcase.to_sym
        unless from &&= from.upcase.to_sym
          case str.encoding
          when 'US-ASCII'; from = :US_ASCII
          when 'UTF-8'   ; from = :UTF8
          when 'UTF-16LE'; from = :UTF16
          end if $vxace
          from ||= to == :UTF8 ? :UTF16 : :UTF8
        end
        super unless CodePages.key?(from) and CodePages.key?(to)
        instance_eval("
        def #{method}(str, dchar=nil, dflag=nil)
          encode#{mark}(str, :#{from}, :#{to}, dchar, dflag)
        rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
        end")
        __send__(method, str, dchar, dflag)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
    end
    module Ini
      @buffer = [].pack('x8').freeze!
      def self.read(filename, section, key, default=nil)
        filename  = (filename[0,1] != '.' && filename[1,1] != ':' ? "./#{filename}\0" : "#{filename}\0").to_utf16!
        section &&= "#{section}\0".to_utf16!
        key     &&= "#{key}\0".to_utf16!
        default &&= "#{default}\0".to_utf16!
        while true
          l = DLL.Kernel32.GetPrivateProfileStringW(section, key, default, @buffer, @buffer.bytesize/2, filename)
          break if l < @buffer.bytesize/2-2
          (@buffer *= 2).freeze!
        end
        @buffer[0, l*2].to_utf8 if l > 0
      end
      def self.write(filename, section, key, value)
        filename  = (filename[0,1] != '.' && filename[1,1] != ':' ? "./#{filename}\0" : "#{filename}\0").to_utf16!
        section &&= "#{section}\0".to_utf16!
        key     &&= "#{key}\0".to_utf16!
        value     = "#{value.is_a?(String) ? value : value.inspect}\0".to_utf16! unless value.nil?
        DLL.Kernel32.WritePrivateProfileStringW(section, key, value, filename)
      end
      def self.sections(filename)                 read(filename, nil, nil).split("\0")     end
      def self.keys(filename, section)            read(filename, section, nil).split("\0") end
      def self.delete_section(filename, section)  write(filename, section, nil, nil)       end
      def self.delete_key(filename, section, key) write(filename, section, key, nil)       end
    end
    module Registry
      Types = [:NONE, :SZ, :EXPAND_SZ, :BINARY, :DWORD, :DWORD_BIG_ENDIAN, :LINK, :MULTI_SZ,
               :RESOURCE_LIST, :FULL_RESOURCE_DESCRIPTOR, :RESOURCE_REQUIREMENTS_LIST, :QWORD]
      BaseKeys = {
        'HKEY_CLASSES_ROOT'        => 0x8000_0000, 'HKCR' => 0x8000_0000,
        'HKEY_CURRENT_USER'        => 0x8000_0001, 'HKCU' => 0x8000_0001,
        'HKEY_LOCAL_MACHINE'       => 0x8000_0002, 'HKLM' => 0x8000_0002,
        'HKEY_USERS'               => 0x8000_0003, 'HKU'  => 0x8000_0003,
        'HKEY_PERFORMANCE_DATA'    => 0x8000_0004, 'HKPD' => 0x8000_0004,
        'HKEY_CURRENT_CONFIG'      => 0x8000_0005, 'HKCC' => 0x8000_0005,
        'HKEY_DYN_DATA'            => 0x8000_0006, 'HKDD' => 0x8000_0006,
        'HKEY_PERFORMANCE_TEXT'    => 0x8000_0050, 'HKPT' => 0x8000_0050,
        'HKEY_PERFORMANCE_NLSTEXT' => 0x8000_0060, 'HKPN' => 0x8000_0060,
      }
      def self.read(key)
        hbasekey, subkey, valuekey = split_key(key)
        return unless hbasekey
        data_size = [].pack('x4')
        return if DLL.Shlwapi.SHGetValueW(hbasekey, subkey, valuekey, nil, nil, data_size) != 0
        type = [].pack('x4')
        data = [].pack("x#{data_size.unpack('L')[0]}")
        DLL.Shlwapi.SHGetValueW(hbasekey, subkey, valuekey, type, data, data_size)
        case Types[type.unpack('L')[0]]
        when :SZ, :EXPAND_SZ  ; data[0, data.index("\0\0")+2].to_utf8!
        when :MULTI_SZ        ; data[0, data.index("\0\0\0\0")+2].to_utf8!.split("\0")
        when :DWORD           ; data.unpack('L')[0]
        when :DWORD_BIG_ENDIAN; data.unpack('N')[0]
        when :QWORD           ; data.unpack('Q')[0]
        else                    data
        end
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.write(key, data, type=nil)
        hbasekey, subkey, valuekey = split_key(key)
        return unless hbasekey
        if type = Types.index(type)
        elsif DLL.Shlwapi.SHGetValueW(hbasekey, subkey, valuekey, type=[].pack('x4'), nil, nil) == 0
          type = type.unpack('L')[0]
        else
          case data
          when nil   ; return
          when Fixnum; type = :DWORD
          when Bignum; type = :QWORD
          when Array ; type = :MULTI_SZ
          when String; type = $vxace && data.encoding.name == 'ASCII-8BIT' ? :BINARY : :SZ
          else         type = :SZ; data = data.to_s
          end
          type = Types.index(type)
        end
        case Types[type]
        when :SZ, :EXPAND_SZ  ; data &&= "#{data}\0".to_utf16!
        when :MULTI_SZ        ; data &&= "#{data.join("\0")}\0\0".to_utf16!
        when :DWORD           ; data &&= [data].pack('L')
        when :DWORD_BIG_ENDIAN; data &&= [data].pack('N')
        when :QWORD           ; data &&= [data].pack('Q')
        end
        DLL.Shlwapi.SHSetValueW(hbasekey, subkey, valuekey, type, data, data ? data.bytesize : 0)
      rescue; raise($!, $!.message, caller($vxace ? 2 : 1))
      end
      def self.split_key(key)
        keys = key.split('\\')
        return if keys.size < 2
        keys[1..-2] = keys[1..-2].join('\\')
        basekey, subkey, valuekey = keys
        return unless hbasekey = BaseKeys[basekey.upcase]
        [hbasekey, "#{subkey}\0".to_utf16!, "#{valuekey}\0".to_utf16!]
      end
    end
    module OS
      def self.windows_version
        @windows_version ||= (
          if ver = Registry.read('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentMajorVersionNumber')
            ver = ver*10 + Registry.read('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentMinorVersionNumber')
            ver = 11_0 if ver == 10_0 and Registry.read('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentBuildNumber').to_i >= 22000
          else
            ver = DLL.Kernel32.GetVersion
            ver = (ver&0xFF)*10 + (ver>>8&0xFF)
          end
          ver
        )
      end
      def self.windows2000_or_greater?()  windows_version >=  5_0 end
      def self.windowsXP_or_greater?()    windows_version >=  5_1 end
      def self.windowsXP_64_or_greater?() windows_version >=  5_2 end
      def self.windowsVista_or_greater?() windows_version >=  6_0 end
      def self.windows7_or_greater?()     windows_version >=  6_1 end
      def self.windows8_or_greater?()     windows_version >=  6_2 end
      def self.windows8_1_or_greater?()   windows_version >=  6_3 end
      def self.windows10_or_greater?()    windows_version >= 10_0 end
      def self.windows11_or_greater?()    windows_version >= 11_0 end
      def self.windows2000?()             windows_version ==  5_0 end
      def self.windowsXP?()               windows_version ==  5_1 end
      def self.windowsXP_64?()            windows_version ==  5_2 end
      def self.windowsVista?()            windows_version ==  6_0 end
      def self.windows7?()                windows_version ==  6_1 end
      def self.windows8?()                windows_version ==  6_2 end
      def self.windows8_1?()              windows_version ==  6_3 end
      def self.windows10?()               windows_version == 10_0 end
      def self.windows11?()               windows_version == 11_0 end
      def self.steamDeck?()         ENV['SteamDeck']      == '1'  end
      def self.steamOSGameMode?()   ENV['SteamOS']        == '1'  end
      def self.steamBigPicture?()   ENV['SteamGamepadUI'] == '1'  end
      def self.proton?()                   proton_version !=  0   end
      def self.proton_version
        @proton_version ||= (
          address = (Zeus::DLL.ntdll.wine_get_version rescue 0)
          Zeus::DLL.Kernel32.RtlMoveMemory§read(ver=[].pack('x2'), address, 2) if address != 0
          ver.to_i
        )
      end
      def self.wow64?
        DLL.Kernel32.IsWow64Process(DLL.Kernel32.GetCurrentProcess, bool=[].pack('x4'))
        bool.unpack('L')[0] == 1
      end
      def self.dwm_composition
        return false unless DLL.Dwmapi.exist?
        DLL.Dwmapi.DwmIsCompositionEnabled(bool=[].pack('x4'))
        bool.unpack('L')[0] == 1
      end
      def self.dwm_composition=(bool)
        DLL.Dwmapi.DwmEnableComposition(bool) if DLL.Dwmapi.exist?
      end
      def self.dpi_awareness
        return 0 unless DLL.Shcore.exist?
        DLL.Shcore.GetProcessDpiAwareness(DLL.Kernel32.GetCurrentProcess, value=[].pack('x4'))
        value.unpack('L')[0]
      end
      def self.dpi_awareness=(value)
        DLL.Shcore.SetProcessDpiAwareness(value) if DLL.Shcore.exist?
      end
      def self.GUID(str)
        /(........)-(....)-(....)-(....)-(....)(........)/.match(str)[1,6].map! {|s| s.to_i(16)}.pack('LS2n2N').freeze!
      end
      def self.profile_path
        @profile_path ||= (
          DLL.Shell32.SHGetFolderPathW(0, 0x28, 0, 0, path=[].pack('x520')) #CSIDL_PROFILE, SHGFP_TYPE_CURRENT
          path[0, path.index("\0\0")+2].to_utf8!
        ).freeze
      end
      def self.saves_path
        @saves_path ||= "#{profile_path}\\Saved Games".freeze
      end
      def self.documents_path
        @documents_path ||= (
          DLL.Shell32.SHGetFolderPathW(0, 0x05, 0, 0, path=[].pack('x520')) #CSIDL_MYDOCUMENTS, SHGFP_TYPE_CURRENT
          path[0, path.index("\0\0")+2].to_utf8!
        ).freeze
      end
      def self.fonts_path
        @fonts_path ||= (
          DLL.Shell32.SHGetFolderPathW(0, 0x14, 0, 0, path=[].pack('x520')) #CSIDL_FONTS, SHGFP_TYPE_CURRENT
          path[0, path.index("\0\0")+2].to_utf8!
        ).freeze
      end
      def self.appdata_path
        @appdata_path ||= (
          DLL.Shell32.SHGetFolderPathW(0, 0x1A, 0, 0, path=[].pack('x520')) #CSIDL_APPDATA, SHGFP_TYPE_CURRENT
          path[0, path.index("\0\0")+2].to_utf8!
        ).freeze
      end
      def self.exe_name
        @exe_name ||= (
          DLL.Kernel32.GetModuleFileNameW(0, name=[].pack('x520'), 260)
          File.basename(name[0, name.index("\0\0")+2].to_utf8!)
        ).freeze
      end
      def self.ini_name
        @ini_name ||= exe_name.sub(/exe$/, 'ini').freeze
      end
      def self.game_title
        @game_title ||= Ini.read(ini_name, 'Game', 'Title').freeze
      end
      def self.rpgmaker_running?(title=game_title, ver=$rgss)
        ver = case ver when :xp; 'XP' when :vx; 'VX' else 'VX Ace' end
        DLL.User32.FindWindowW(nil, "#{title} - RPG Maker #{ver}\0".to_utf16!) != 0
      end
      def self.copy_file(from, to, overwrite=false)
        DLL.Kernel32.CopyFileW("#{from}\0".to_utf16!, "#{to}\0".to_utf16!, !overwrite)
      end
      def self.create_directory(directory)
        path = ''
        directory.split('/').each do |folder|
          path << folder
          DLL.Kernel32.CreateDirectoryW("#{path}\0".to_utf16!, nil) unless FileTest.exist?(path)
          path << '/'
        end
      end
    end
    module Animation
      Data = Struct.new(:name, :setter, :method, :base, :target, :count, :duration, :easing, :exponent, :map, :ext, :callback)
      attr_reader :za_animations
      def initialize_copy(o)
        super
        za_initialize
      end
      def za_initialize
        @za_animations = {}
        @za_memorize   = {}
        nil
      end
      def za_animate(name, target, duration=0, easing=:linear, exponent=2, map=false, ext=nil, callback=block_given?&&proc)
        @za_animations[name] = data = Data.new(
          name, !(name_s=name.to_s).start_with?('@') && :"#{name_s}=", nil, nil, target.is_a?(Array) ? za_get_target(name).__send__(*target) : target,
          0, (duration.is_a?(Float) ? (duration*Graphics.frame_rate).round : duration).to_f, easing, exponent, map, ext, callback
        )
        data.base   = za_get_value(data).deep_dup
        data.method = :"za_update_#{data.setter ? name_s : name_s[1..-1]}"
        case data.base
        when Numeric    ; data.method = :za_update_Numeric
        when Color      ; data.method = :za_update_Color
        when Tone       ; data.method = :za_update_Tone
        when Rect, RectF; data.method = :za_update_Rect
        else              data.method = :"za_update_#{data.base.class.name[/\w+$/]}"
        end unless respond_to?(data.method)
        if data.duration <= 0
          data.count = data.duration = 1
          za_update(name)
        end
        nil
      end
      def za_add(name, value, duration=0, easing=:linear, exponent=2, map=false, ext=nil, callback=block_given?&&proc)
        za_animate(name, za_get_target(name)+value, duration, easing, exponent, map, ext, callback)
      end
      def za_mul(name, value, duration=0, easing=:linear, exponent=2, map=false, ext=nil, callback=block_given?&&proc)
        za_animate(name, za_get_target(name)*value, duration, easing, exponent, map, ext, callback)
      end
      def za_animating?(name=nil)
        name ? @za_animations.key?(name) : !@za_animations.empty?
      end
      def za_clear(name=nil)
        name ? @za_animations.delete(name) : @za_animations.clear
        nil
      end
      def za_memorize(name=nil)
        name ? @za_animations[name] && @za_memorize[name] = Marshal.dump(@za_animations[name]) :
               @za_animations.each_key {|name| za_memorize(name)}
        nil
      end
      def za_restore(name=nil)
        name ? @za_memorize[name] && @za_animations[name] = Marshal.load(@za_memorize[name]) :
               @za_memorize.each_key {|name| za_restore(name)}
        nil
      end
      def za_terminate(name=nil)
        if name
          return unless data = @za_animations[name]
          data.count = data.duration
          za_update(name)
        else
          @za_animations.each_key {|name| za_terminate(name)}
        end
        nil
      end
      def za_update(name=nil)
        if name
          return unless data = @za_animations[name]
          data.count = Math.min(data.count+(data.map ? $game_map.time_speed : 1), data.duration)
          __send__(data.method, data)
          if data.count == data.duration
            case data.callback
            when String; cache_eval(data.callback)
            when Symbol; __send__(data.callback)
            when Array ; data.callback[0].__send__(data.callback[1], *data.callback[2])
            when Proc  ; data.callback.call(self)
            end
            @za_animations.delete(name)
          end
        else
          @za_animations.each_key {|name| za_update(name)}
        end
        nil
      end
      def za_set_ext(name, ext)
        data = @za_animations[name] and data.ext = ext
      end
      def za_get_ext(name)
        data = @za_animations[name] and data.ext
      end
      def za_set_target(name, target)
        if data = @za_animations[name]
          data.duration -= data.count
          data.count     = 0
          data.base      = za_get_value(data)
          data.target    = target
        else
          name.to_s.start_with?('@') ? instance_variable_set(name, target) : __send__("#{name}=", target)
        end
      end
      def za_get_target(name, default=nil)
        if data = @za_animations[name]
          data.target
        else
          default or block_given? && yield or name.to_s.start_with?('@') ? instance_variable_get(name) : __send__(name)
        end
      end
      def za_get_value(data)
        data.setter ? __send__(data.name)          : instance_variable_get(data.name)
      end
      def za_set_value(data, value)
        data.setter ? __send__(data.setter, value) : instance_variable_set(data.name, value)
      end
      def za_next_value(data, base=data.base, target=data.target)
        value = (target-base) * Math.easing(data.count/data.duration, data.easing, data.exponent)
        base + (base.is_a?(Integer) ? value.to_i : value)
      end
      def za_update_Numeric(data)
        za_set_value(data, za_next_value(data))
      end
      def za_update_Color(data)
        za_get_value(data).set(
          za_next_value(data, data.base.red  , data.target.red  ),
          za_next_value(data, data.base.green, data.target.green),
          za_next_value(data, data.base.blue , data.target.blue ),
          za_next_value(data, data.base.alpha, data.target.alpha)
        )
      end
      def za_update_Tone(data)
        za_get_value(data).set(
          za_next_value(data, data.base.red  , data.target.red  ),
          za_next_value(data, data.base.green, data.target.green),
          za_next_value(data, data.base.blue , data.target.blue ),
          za_next_value(data, data.base.gray , data.target.gray )
        )
      end
      def za_update_Rect(data)
        za_get_value(data).set(
          za_next_value(data, data.base.x     , data.target.x     ),
          za_next_value(data, data.base.y     , data.target.y     ),
          za_next_value(data, data.base.width , data.target.width ),
          za_next_value(data, data.base.height, data.target.height)
        )
      end
    end
  end

  module Graphics
    @frame_timeA, @frame_timeB, @frame_dropped, @before_update, @after_update, @on_reset = 0, 0, false, [], [], []
    unless @frame_drop_buffer
      @frame_drop_buffer_ptr = (@frame_drop_buffer = [].pack('x16').freeze!).address
      Zeus::DLL.Kernel32.QueryPerformanceFrequency(@frame_drop_buffer)
      @frame_drop_threshold = (QPFrequency = @frame_drop_buffer.unpack('Q')[0]) / 1000
    end
    class << self
      attr_accessor :frame_timeA, :frame_timeB, :frame_dropped
      def before_update(&p) @before_update << p                                        end
      def after_update(&p)  @after_update  << p                                        end
      def on_reset(&p)      $vxace ? @on_reset << p : p.call                           end
      def on_reset!()       @on_reset.each {|p| p.call}                                end
      def zeus_clear()      @before_update.clear; @after_update.clear; @on_reset.clear end
      def hwnd()
        @hwnd ||= (
          title = (title = Zeus::OS.game_title).empty? ? nil : "#{title}\0".to_utf16!
          Zeus::DLL.User32.FindWindowW("RGSS Player\0".to_utf16!, title)
        )
      end
      alias zeus_update update unless method_defined?(:zeus_update)
      def update
        @before_update.each {|p| p.call}
        frame_reset if $vxace and @gc_count != @gc_count = GC.count
        Zeus::DLL.Kernel32.QueryPerformanceCounter(@frame_drop_buffer_ptr)
        zeus_update
        Zeus::DLL.Kernel32.QueryPerformanceCounter(@frame_drop_buffer_ptr+8)
        @frame_timeA, @frame_timeB = @frame_drop_buffer.unpack('Q2')
        @frame_dropped = @frame_timeB - @frame_timeA < @frame_drop_threshold if @frame_drop_threshold > 0
        @after_update.each {|p| p.call}
        nil
      end
    end
  end
  
  class Object
    alias zeus_rgss_main rgss_main unless private_method_defined?(:zeus_rgss_main)
    def rgss_main() zeus_rgss_main {Graphics.on_reset!; yield} end
  end if $vxace
  
  Zeus::DLL.Kernel32.SetDllDirectoryW("System\0".to_utf16!)
end
Graphics.zeus_clear