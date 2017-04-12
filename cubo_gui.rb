require_relative 'cubo'

class CuboGUI < Gosu::Window
  def initialize(cubo)
    super 800, 600
    @cubo = cubo
    self.caption = "Cube Simulator"
    #puts @cubo
    @apertados = {'r' => 0, 'u' => 0, 'f' => 0, 'l' => 0, 'b' => 0, 'd' => 0}
    @cooldown = 10
    @frame_count = 0
    @solving = false
    @moves = 0
    @texto = Gosu::Font.new(20)
  end

  def update
    @cubo.speffz
    if @solving && @cubo.stack.length == 0
      if @cubo.solve_next_edge
        @cubo.solve_next_corner
      end
    end
    @frame_count += 1
    if @frame_count % 2 == 0
      if @cubo.stack.length > 0
        @moves += 1
        @cubo.move
      end
    end
    if @apertados['r'] == @cooldown
      @cubo.r
    end
    if @apertados['r'] > 0
      @apertados['r'] -= 1
    end
    if @apertados['u'] == @cooldown
      @cubo.u
    end
    if @apertados['u'] > 0
      @apertados['u'] -= 1
    end
    if @apertados['f'] == @cooldown
      @cubo.f
    end
    if @apertados['f'] > 0
      @apertados['f'] -= 1
    end
    if @apertados['l'] == @cooldown
      @cubo.l
    end
    if @apertados['l'] > 0
      @apertados['l'] -= 1
    end
    if @apertados['b'] == @cooldown
      @cubo.b
    end
    if @apertados['b'] > 0
      @apertados['b'] -= 1
    end
    if @apertados['d'] == @cooldown
      @cubo.d
    end
    if @apertados['d'] > 0
      @apertados['d'] -= 1
    end
  end

  def draw
    draw_cubo
    @texto.draw("Moves: #{@moves}", 5, 30, 1)
  end

  def draw_cubo
    @cubo.cubo.each do |chave, valores|
      offset_x = 0
      offset_y = 0
      if chave == 'l'
        offset_y = 90
      elsif chave == 'u'
        offset_x = 90
      elsif chave == 'f'
        offset_x = 90
        offset_y = 90
      elsif chave == 'r'
        offset_x = 180
        offset_y = 90
      elsif chave == 'b'
        offset_x = 270
        offset_y = 90
      elsif chave == 'd'
        offset_x = 90
        offset_y = 180
      end
      for i in 0...3
        for j in 0...3
          Gosu.draw_rect(i * 30 + offset_x, j * 30 + offset_y, 30, 30, valores[i + 3 * j], 0, :default)
        end
      end
    end
  end

  def button_down(id)
    case id
    when Gosu::KB_ESCAPE
      close
    when Gosu::KB_R
      if @apertados['r'] == 0
        @apertados['r'] = @cooldown
      end
    when Gosu::KB_U
      if @apertados['u'] == 0
        @apertados['u'] = @cooldown
      end
    when Gosu::KB_F
      if @apertados['f'] == 0
        @apertados['f'] = @cooldown
      end
    when Gosu::KB_L
      if @apertados['l'] == 0
        @apertados['l'] = @cooldown
      end
    when Gosu::KB_B
      if @apertados['b'] == 0
        @apertados['b'] = @cooldown
      end
    when Gosu::KB_D
      if @apertados['d'] == 0
        @apertados['d'] = @cooldown
      end
    when Gosu::KB_M
      @cubo.m
    when Gosu::KB_S
      @cubo.embaralha
    when Gosu::KB_T
      @cubo.t
    when Gosu::KB_Y
      @cubo.y
    when Gosu::KB_Z
      unless @solving
        @moves = 0
      end
      @solving = !@solving
    end
  end
end


cubo = Cubo.new
CuboGUI.new(cubo).show
