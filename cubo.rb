require 'gosu'

class Cubo
  attr_reader :stack
  def initialize
    @cubo = {}
    lados = ['f', 'r', 'u', 'l', 'd', 'b']
    @green = Gosu::Color.argb(0xff_00ff00)
    @red = Gosu::Color.argb(0xff_ff0000)
    @white = Gosu::Color.argb(0xff_ffffff)
    @orange = Gosu::Color.argb(0xff_ffa700)
    @yellow = Gosu::Color.argb(0xff_ffff00)
    @blue = Gosu::Color.argb(0xff_0000ff)
    cores = [@green, @red, @white, @orange, @yellow, @blue]
    for i in 0..5 do
      arr = []
      for j in 0..8 do
        arr << cores[i]
      end
      @cubo[lados[i]] = arr
    end
    @stack = []
    @corners = {}
    @edges = {}
    speffz
    @solved_corners = @corners.clone
    @solved_edges = @edges.clone
  end

  def push str
    str.upcase.split.each do |move|
      @stack << move
    end
  end

  def move
    move = @stack.shift
    case move
    when "R"
      self.r
    when "R'"
      self.r_linha
    when "R2"
      self.r2
    when "U"
      self.u
    when "U'"
      self.u_linha
    when "U2"
      self.u2
    when "F"
      self.f
    when "F'"
      self.f_linha
    when "F2"
      self.f2
    when "L"
      self.l
    when "L'"
      self.l_linha
    when "L2"
      self.l2
    when "D"
      self.d
    when "D'"
      self.d_linha
    when "D2"
      self.d2
    when "B"
      self.b
    when "B'"
      self.b_linha
    when "B2"
      self.b2
    when "M"
      self.m
    when "M'"
      self.m_linha
    when "M2"
      self.m2
    end
  end

  def cubo
    @cubo
  end

  def to_s
    scr = "   #{@cubo['u'][0]}#{@cubo['u'][1]}#{@cubo['u'][2]}\n"
    scr << "   #{@cubo['u'][3]}#{@cubo['u'][4]}#{@cubo['u'][5]}\n"
    scr << "   #{@cubo['u'][6]}#{@cubo['u'][7]}#{@cubo['u'][8]}\n"
    scr << "#{@cubo['l'][0]}#{@cubo['l'][1]}#{@cubo['l'][2]}"
    scr << "#{@cubo['f'][0]}#{@cubo['f'][1]}#{@cubo['f'][2]}"
    scr << "#{@cubo['r'][0]}#{@cubo['r'][1]}#{@cubo['r'][2]}"
    scr << "#{@cubo['b'][0]}#{@cubo['b'][1]}#{@cubo['b'][2]}\n"
    scr << "#{@cubo['l'][3]}#{@cubo['l'][4]}#{@cubo['l'][5]}"
    scr << "#{@cubo['f'][3]}#{@cubo['f'][4]}#{@cubo['f'][5]}"
    scr << "#{@cubo['r'][3]}#{@cubo['r'][4]}#{@cubo['r'][5]}"
    scr << "#{@cubo['b'][3]}#{@cubo['b'][4]}#{@cubo['b'][5]}\n"
    scr << "#{@cubo['l'][6]}#{@cubo['l'][7]}#{@cubo['l'][8]}"
    scr << "#{@cubo['f'][6]}#{@cubo['f'][7]}#{@cubo['f'][8]}"
    scr << "#{@cubo['r'][6]}#{@cubo['r'][7]}#{@cubo['r'][8]}"
    scr << "#{@cubo['b'][6]}#{@cubo['b'][7]}#{@cubo['b'][8]}\n"
    scr <<  "   #{@cubo['d'][0]}#{@cubo['d'][1]}#{@cubo['d'][2]}\n"
    scr << "   #{@cubo['d'][3]}#{@cubo['d'][4]}#{@cubo['d'][5]}\n"
    scr << "   #{@cubo['d'][6]}#{@cubo['d'][7]}#{@cubo['d'][8]}\n"
  end

  def inverte face, n
  #  aux = @cubo[face][0]
  #  @cubo[face][0] = @cubo[face][2]
  #  @cubo[face][2] = aux
  #  aux = @cubo[face][3]
  #  @cubo[face][3] = @cubo[face][5]
  #  @cubo[face][5] = aux
  #  aux = @cubo[face][6]
  #  @cubo[face][6] = @cubo[face][8]
  #  @cubo[face][8] = aux
    n.times {
      turn_edges face
      turn_corners face
    }
  end

  def t
    push "R U R' U' R' F R2 U' R' U' R U R' F'"
  end

  def y
    push "F R U' R' U' R U R' F' R U R' U' R' F R F'"
  end

  def r
    turn_edges 'r'
    turn_corners 'r'
    inverte 'b', 2
    troca_faces ['f', 'u', 'b', 'd'], [2, 5, 8]
    inverte 'b', 2
  end

  def r2
    2.times { r }
  end

  def r_linha
    3.times { r }
  end

  def u
    turn_edges 'u'
    turn_corners 'u'
    troca_faces ['l', 'b', 'r', 'f'], [0, 1, 2]
  end

  def u2
    2.times { u }
  end

  def u_linha
    3.times { u }
  end

  def f
    turn_edges 'f'
    turn_corners 'f'
    inverte 'l', 1
    inverte 'r', 3
    inverte 'd', 2
    troca_faces ['l', 'u', 'r', 'd'], [6, 7, 8]
    inverte 'l', 3
    inverte 'r', 1
    inverte 'd', 2
  end

  def f2
    2.times { f }
  end

  def f_linha
    3.times { f }
  end

  def l
    turn_edges 'l'
    turn_corners 'l'
    inverte 'b', 2
    troca_faces ['f', 'd', 'b', 'u'], [0, 3, 6]
    inverte 'b', 2
  end

  def l2
    2.times { l }
  end

  def l_linha
    3.times { l }
  end

  def d
    turn_edges 'd'
    turn_corners 'd'
    troca_faces ['f', 'r', 'b', 'l'], [6, 7, 8]
  end

  def d2
    2.times { d }
  end

  def d_linha
    3.times { d }
  end

  def b
    turn_edges 'b'
    turn_corners 'b'
    inverte 'l', 1
    inverte 'r', 3
    inverte 'd', 2
    troca_faces ['d', 'r', 'u', 'l'], [0, 1, 2]
    inverte 'l', 3
    inverte 'r', 1
    inverte 'd', 2
  end

  def b2
    2.times { b }
  end

  def b_linha
    3.times { b }
  end

  def turn_edges side
    aux = @cubo[side][1]
    @cubo[side][1] = @cubo[side][3]
    @cubo[side][3] = @cubo[side][7]
    @cubo[side][7] = @cubo[side][5]
    @cubo[side][5] = aux
  end

  def turn_corners side
    aux = @cubo[side][0]
    @cubo[side][0] = @cubo[side][6]
    @cubo[side][6] = @cubo[side][8]
    @cubo[side][8] = @cubo[side][2]
    @cubo[side][2] = aux
  end

  def troca_faces faces, pecas
    #inverte faces[2]
    aux = [@cubo[faces[0]][pecas[0]], @cubo[faces[0]][pecas[1]], @cubo[faces[0]][pecas[2]]]
    for j in 0..2
      @cubo[faces[0]][pecas[j]] = @cubo[faces[3]][pecas[j]]
    end
    for j in 0..2
      @cubo[faces[3]][pecas[j]] = @cubo[faces[2]][pecas[j]]
    end
    for j in 0..2
      @cubo[faces[2]][pecas[j]] = @cubo[faces[1]][pecas[j]]
    end
    for j in 0..2
      @cubo[faces[1]][pecas[j]] = aux[j]
    end
    #inverte faces[2]
  end

  def m
    aux = @cubo['u'][4]
    @cubo['u'][4] = @cubo['b'][4]
    @cubo['b'][4] = @cubo['d'][4]
    @cubo['d'][4] = @cubo['f'][4]
    @cubo['f'][4] = aux

    aux = @cubo['u'][1]
    @cubo['u'][1] = @cubo['b'][7]
    @cubo['b'][7] = @cubo['d'][1]
    @cubo['d'][1] = @cubo['f'][1]
    @cubo['f'][1] = aux

    aux = @cubo['u'][7]
    @cubo['u'][7] = @cubo['b'][1]
    @cubo['b'][1] = @cubo['d'][7]
    @cubo['d'][7] = @cubo['f'][7]
    @cubo['f'][7] = aux
  end

  def m_linha
    3.times {
      m
    }
  end

  def m2
    2.times {
      m
    }
  end

  def speffz
    #u face
    @corners[:a] = @cubo['u'][0]
    @edges[:a] = @cubo['u'][1]
    @corners[:b] = @cubo['u'][2]
    @edges[:b] = @cubo['u'][5]
    @corners[:c] = @cubo['u'][8]
    @edges[:c] = @cubo['u'][7]
    @corners[:d] = @cubo['u'][6]
    @edges[:d] = @cubo['u'][3]

    #l face
    @corners[:e] = @cubo['l'][0]
    @edges[:e] = @cubo['l'][1]
    @corners[:f] = @cubo['l'][2]
    @edges[:f] = @cubo['l'][5]
    @corners[:g] = @cubo['l'][8]
    @edges[:g] = @cubo['l'][7]
    @corners[:h] = @cubo['l'][6]
    @edges[:h] = @cubo['l'][3]

    #f face
    @corners[:i] = @cubo['f'][0]
    @edges[:i] = @cubo['f'][1]
    @corners[:j] = @cubo['f'][2]
    @edges[:j] = @cubo['f'][5]
    @corners[:k] = @cubo['f'][8]
    @edges[:k] = @cubo['f'][7]
    @corners[:l] = @cubo['f'][6]
    @edges[:l] = @cubo['f'][3]

    #r face
    @corners[:m] = @cubo['r'][0]
    @edges[:m] = @cubo['r'][1]
    @corners[:n] = @cubo['r'][2]
    @edges[:n] = @cubo['r'][5]
    @corners[:o] = @cubo['r'][8]
    @edges[:o] = @cubo['r'][7]
    @corners[:p] = @cubo['r'][6]
    @edges[:p] = @cubo['r'][3]

    #b face
    @corners[:q] = @cubo['b'][0]
    @edges[:q] = @cubo['b'][1]
    @corners[:r] = @cubo['b'][2]
    @edges[:r] = @cubo['b'][5]
    @corners[:s] = @cubo['b'][8]
    @edges[:s] = @cubo['b'][7]
    @corners[:t] = @cubo['b'][6]
    @edges[:t] = @cubo['b'][3]

    #d face
    @corners[:u] = @cubo['d'][0]
    @edges[:u] = @cubo['d'][1]
    @corners[:v] = @cubo['d'][2]
    @edges[:v] = @cubo['d'][5]
    @corners[:w] = @cubo['d'][8]
    @edges[:w] = @cubo['d'][7]
    @corners[:x] = @cubo['d'][6]
    @edges[:x] = @cubo['d'][3]
  end

  #TODO: remake the scramble method
  def embaralha
    scramble = ""
    last = ""
    embaralhado = {f:  true, r: true, u: true, b: true, l:true, d: true}
    i = 0
    while i < 30
      sides = [:f, :r, :u, :b, :l, ]
      current = sides.shuffle.first
      if current == last
        loop
      elsif embaralhado[current] != true
        loop
      else
        attribute = [" ", "' ", "2 "].shuffle.first
        case current
        when :f, :b
          move = "#{current.upcase}#{attribute}"
          scramble << move
          embaralhado.each { |k, v| embaralhado[k] = true }
          embaralhado[:f] = false
          embaralhado[:b] = false
          i += 1
        when :r, :l
          move = "#{current.upcase}#{attribute}"
          scramble << move
          embaralhado.each { |k, v| embaralhado[k] = true }
          embaralhado[:r] = false
          embaralhado[:l] = false
          i += 1
        when :u,
          move = "#{current.upcase}#{attribute}"
          scramble << move
          embaralhado.each { |k, v| embaralhado[k] = true }
          embaralhado[:u] = false
          embaralhado[:d] = false
          i += 1
        end
      end
    end
    self.push scramble
    while @stack.size > 0
      self.move
    end
  end

  def edge_solved? e
    peca = [e]
    adj = find_neighbor e
    peca << adj
    peca.each { |target|
      if @edges[target] != @solved_edges[target]
         return false
      end
    }
    return true
  end

  def find_neighbor e
    case e
    when :a
      return :q
    when :b
      return :m
    when :c
      return :i
    when :d
      return :e
    when :e
      return :d
    when :f
      return :l
    when :g
      return :x
    when :h
      return :r
    when :i
      return :c
    when :j
      return :p
    when :k
      return :u
    when :l
      return :f
    when :m
      return :b
    when :n
      return :t
    when :o
      return :v
    when :p
      return :j
    when :q
      return :a
    when :r
      return :h
    when :s
      return :w
    when :t
      return :n
    when :u
      return :k
    when :v
      return :o
    when :w
      return :s
    when :x
      return :g
    end
  end

  def edges_solved?
    @edges.each_key { |k|
      if @edges[k] != @solved_edges[k]
        return false
      end
    }
    true
  end

  def solve_edges
    20.times { solve_next }
    if @cubo['f'][4] == @blue then push "D' L2 D M2 D' L2 D" end
  end

  def find_unsolved_edge
    ed = @edges.clone
    ed = ed.to_a.shuffle.to_h
    ed.each_key { |k|
      if ed[k] != @solved_edges[k] && k != :u && k != :k
         return k
      end
    }
  end

  def paridade?
    return (@edges[:a] == @white  && @edges[:q] == @blue  &&
    @edges[:s] == @green  && @edges[:w] == @white &&
    @edges[:u] == @yellow && @edges[:k] == @green &&
    @edges[:i] == @blue   && @edges[:c] == @yellow)
  end

  def pos_paridade?
    ed = @edges.clone
    aux = ed[:q]
    ed[:q] = ed[:e]
    ed[:e] = aux
    ed.each_key { |k|
      return false if ed[k] != @solved_edges[k]
    }
    true
  end

  def solve_next_edge
    unless edges_solved? || pos_paridade?
      if edge_solved? :u
        if paridade?
          push "D' L2 D M2 D' L2 D"
          return true
        elsif pos_paridade?
          return true
        end
        peca = find_unsolved_edge
      else
        peca = :u
      end
      vizinho = find_neighbor peca
      case @edges[peca]
      when @green
        case @edges[vizinho]
        when @white
          if @cubo['f'][4] == @green
            push "D M' U R2 U' M U R2 U' D' M2"
          else
            push "M2 D U R2 U' M' U R2 U' M D'"
          end
        when @yellow
        when @orange
          push "U' L' U M2 U' L U"
        when @red
          push "U R U' M2 U R' U'"
        end
      when @orange
        case @edges[vizinho]
        when @white
          push "B L' B M2 B L B"
        when @green
          push "B L2 B' M2 B L2 B'"
        when @yellow
          push "B L B' M2 B L' B'"
        when @blue
          push "L' B L B' M2 B L' B' L"
        end
      when @red
        case @edges[vizinho]
        when @white
          push "B' R B M2 B' R' B"
        when @blue
          push "R B' R' B M2 B' R B R'"
        when @yellow
          push "B' R' B M2 B' R B"
        when @green
          push "B' R2 B M2 B' R2 B"
        end
      when @blue
        case @edges[vizinho]
        when @white
          push "B' R' B R' U R U' M2 U R' U' R B' R B"
        when @red
          push "U R' U' M2 U R U'"
        when @yellow
          if @cubo['f'][4] == @green
            push "M2 D U R2 U' M' U R2 U' M D'"
          else
            push "D M' U R2 U' M U R2 U' D' M2"
          end
        when @orange
          push "U' L U M2 U' L' U"
        end
      when @white
        case @edges[vizinho]
        when @blue
          push "M2"
        when @red
          push "R' U R U' M2 U R' U' R"
        when @green
          if @cubo['f'][4] == @green
            push "U2 M' U2 M'"
          else
            push "M U2 M U2"
          end
        when @orange
          push "L U' L' U M2 U' L U L'"
        end
      when @yellow
        case @edges[vizinho]
        when @green
        when @red
          push "U R2 U' M2 U R2 U'"
        when @blue
          if @cubo['f'][4] == @green
            push "M U2 M U2"
          else
            push "U2 M' U2 M'"
          end
        when @orange
          push "U' L2 U M2 U' L2 U"
        end
      end
    else
      return true
    end
    false
  end

  def find_neighbors c
    case c
    when :a
      return [:e, :r]
    when :b
      return [:q, :n]
    when :c
      return [:j, :m]
    when :d
      return [:f, :i]
    when :e
      return [:a, :r]
    when :f
      return [:d, :i]
    when :g
      return [:l, :u]
    when :h
      return [:x, :s]
    when :i
      return [:f, :d]
    when :j
      return [:c, :m]
    when :k
      return [:v, :p]
    when :l
      return [:g, :u]
    when :m
      return [:d, :j]
    when :n
      return [:q, :b]
    when :o
      return [:t, :w]
    when :p
      return [:v, :k]
    when :q
      return [:b, :n]
    when :r
      return [:e, :a]
    when :s
      return [:h, :x]
    when :t
      return [:w, :o]
    when :u
      return [:g, :l]
    when :v
      return [:p, :k]
    when :w
      return [:o, :t]
    when :x
      return [:h, :s]
    end
  end

  def corner_solved? c
    peca = [c]
    peca.concat find_neighbors c
    peca.each { |k|
      if @corners[k] != @solved_corners[k] then return false end
    }
    true
  end

  def corners_solved?
    @corners.each_key { |k|
      if @corners[k] != @solved_corners[k]
        return false
      end
    }
    true
  end

  def find_unsolved_corner
    puts "searching"
    speffz
    @corners.each_key { |k|
      if @corners[k] != @solved_corners[k] && k != :a && k != :e && k != :r
        puts k
        return k
      end
    }
  end

  def corner_buffer_in_place?
    speffz
    if corner_solved? :a then return true end
    if (@corners[:a] == @blue && @corners[:e] == @white && @corners[:r] == @orange) then return true end
    if (@corners[:e] == @blue && @corners[:r] == @white && @corners[:a] == @orange) then return true end
    false
  end

  def solve_next_corner
    unless corners_solved?
      if corner_buffer_in_place?
        peca = find_unsolved_corner
      else
        peca = :a
      end
      vizinhos = find_neighbors peca
      vizinhos = vizinhos.map { |s| @corners[s]}
      case @corners[peca]
      when @white
        if vizinhos.include?(@blue) && vizinhos.include?(@orange)
        elsif vizinhos.include?(@green) && vizinhos.include?(@orange)
          push "U2 R U2 R' U' R U2 L' U R' U' L U2"
        elsif vizinhos.include?(@green) && vizinhos.include?(@red)
          y
        elsif vizinhos.include?(@blue) && vizinhos.include?(@red)
          push "U R' U2 R U R' U2 L U' R U L' U'"
        end
      when @orange
        if vizinhos.include?@blue && vizinhos.include?(@white)
        elsif vizinhos.include?(@white) && vizinhos.include?(@green)
          push "F"
          y
          push "F'"
        elsif vizinhos.include?(@green) && vizinhos.include?(@yellow)
          push "D R"
          y
          push "R' D'"
        elsif vizinhos.include?(@blue) && vizinhos.include?(@yellow)
          push "D2 F'"
          y
          push "F D2"
        end
      when @green
        if vizinhos.include?(@orange) && vizinhos.include?(@white)
          push "F2 R"
          y
          push "R' F2"
        elsif vizinhos.include?(@white) && vizinhos.include?(@red)
          push "F R"
          y
          push "R' F'"
        elsif vizinhos.include?(@red) && vizinhos.include?(@yellow)
          push "R"
          y
          push "R'"
        elsif vizinhos.include?(@orange) && vizinhos.include?(@yellow)
          push "F' R"
          y
          push "R' F"
        end
      when @red
        if vizinhos.include?(@green) && vizinhos.include?(@white)
          push "R' F'"
          y
          push "F R"
        elsif vizinhos.include?(@white) && vizinhos.include?(@blue)
          push "R2 F'"
          y
          push "F R2"
        elsif vizinhos.include?(@blue) && vizinhos.include?(@yellow)
          push "D' R"
          y
          push "R' D"
        elsif vizinhos.include?(@green) && vizinhos.include?(@yellow)
          push "F'"
          y
          push "F"
        end
      when @blue
        if vizinhos.include?(@red) && vizinhos.include?(@white)
          push "R'"
          y
          push "R"
        elsif vizinhos.include?(@white) && vizinhos.include?(@orange)
        elsif vizinhos.include?(@orange) && vizinhos.include?(@yellow)
          push "D2 R"
          y
          push "R' D2"
        elsif vizinhos.include?(@red) && vizinhos.include?(@yellow)
          push "D' F'"
          y
          push "F D"
        end
      when @yellow
        if vizinhos.include?(@green) && vizinhos.include?(@orange)
          push "F2"
          y
          push "F2"
        elsif vizinhos.include?(@red) && vizinhos.include?(@green)
          push "D R2"
          y
          push "R2 D'"
        elsif vizinhos.include?(@blue) && vizinhos.include?(@red)
          push "R2"
          y
          push "R2"
        elsif vizinhos.include?(@orange) && vizinhos.include?(@blue)
          push "D' R2"
          y
          push "R2 D"
        end
      end
    end
  end

  def cor_igual? a, b
    a.red == b.red && a.green == b.green && a.blue == b.blue
  end

end
