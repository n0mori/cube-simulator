require 'gosu'

class Cube
  attr_reader :stack
  def initialize
    @cube = {}
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
      @cube[lados[i]] = arr
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

  def cube
    @cube
  end

  def to_s
    scr = "   #{@cube['u'][0]}#{@cube['u'][1]}#{@cube['u'][2]}\n"
    scr << "   #{@cube['u'][3]}#{@cube['u'][4]}#{@cube['u'][5]}\n"
    scr << "   #{@cube['u'][6]}#{@cube['u'][7]}#{@cube['u'][8]}\n"
    scr << "#{@cube['l'][0]}#{@cube['l'][1]}#{@cube['l'][2]}"
    scr << "#{@cube['f'][0]}#{@cube['f'][1]}#{@cube['f'][2]}"
    scr << "#{@cube['r'][0]}#{@cube['r'][1]}#{@cube['r'][2]}"
    scr << "#{@cube['b'][0]}#{@cube['b'][1]}#{@cube['b'][2]}\n"
    scr << "#{@cube['l'][3]}#{@cube['l'][4]}#{@cube['l'][5]}"
    scr << "#{@cube['f'][3]}#{@cube['f'][4]}#{@cube['f'][5]}"
    scr << "#{@cube['r'][3]}#{@cube['r'][4]}#{@cube['r'][5]}"
    scr << "#{@cube['b'][3]}#{@cube['b'][4]}#{@cube['b'][5]}\n"
    scr << "#{@cube['l'][6]}#{@cube['l'][7]}#{@cube['l'][8]}"
    scr << "#{@cube['f'][6]}#{@cube['f'][7]}#{@cube['f'][8]}"
    scr << "#{@cube['r'][6]}#{@cube['r'][7]}#{@cube['r'][8]}"
    scr << "#{@cube['b'][6]}#{@cube['b'][7]}#{@cube['b'][8]}\n"
    scr <<  "   #{@cube['d'][0]}#{@cube['d'][1]}#{@cube['d'][2]}\n"
    scr << "   #{@cube['d'][3]}#{@cube['d'][4]}#{@cube['d'][5]}\n"
    scr << "   #{@cube['d'][6]}#{@cube['d'][7]}#{@cube['d'][8]}\n"
  end

  def inverte face, n
  #  aux = @cube[face][0]
  #  @cube[face][0] = @cube[face][2]
  #  @cube[face][2] = aux
  #  aux = @cube[face][3]
  #  @cube[face][3] = @cube[face][5]
  #  @cube[face][5] = aux
  #  aux = @cube[face][6]
  #  @cube[face][6] = @cube[face][8]
  #  @cube[face][8] = aux
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
    aux = @cube[side][1]
    @cube[side][1] = @cube[side][3]
    @cube[side][3] = @cube[side][7]
    @cube[side][7] = @cube[side][5]
    @cube[side][5] = aux
  end

  def turn_corners side
    aux = @cube[side][0]
    @cube[side][0] = @cube[side][6]
    @cube[side][6] = @cube[side][8]
    @cube[side][8] = @cube[side][2]
    @cube[side][2] = aux
  end

  def troca_faces faces, pecas
    #inverte faces[2]
    aux = [@cube[faces[0]][pecas[0]], @cube[faces[0]][pecas[1]], @cube[faces[0]][pecas[2]]]
    for j in 0..2
      @cube[faces[0]][pecas[j]] = @cube[faces[3]][pecas[j]]
    end
    for j in 0..2
      @cube[faces[3]][pecas[j]] = @cube[faces[2]][pecas[j]]
    end
    for j in 0..2
      @cube[faces[2]][pecas[j]] = @cube[faces[1]][pecas[j]]
    end
    for j in 0..2
      @cube[faces[1]][pecas[j]] = aux[j]
    end
    #inverte faces[2]
  end

  def m
    aux = @cube['u'][4]
    @cube['u'][4] = @cube['b'][4]
    @cube['b'][4] = @cube['d'][4]
    @cube['d'][4] = @cube['f'][4]
    @cube['f'][4] = aux

    aux = @cube['u'][1]
    @cube['u'][1] = @cube['b'][7]
    @cube['b'][7] = @cube['d'][1]
    @cube['d'][1] = @cube['f'][1]
    @cube['f'][1] = aux

    aux = @cube['u'][7]
    @cube['u'][7] = @cube['b'][1]
    @cube['b'][1] = @cube['d'][7]
    @cube['d'][7] = @cube['f'][7]
    @cube['f'][7] = aux
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
    @corners[:a] = @cube['u'][0]
    @edges[:a] = @cube['u'][1]
    @corners[:b] = @cube['u'][2]
    @edges[:b] = @cube['u'][5]
    @corners[:c] = @cube['u'][8]
    @edges[:c] = @cube['u'][7]
    @corners[:d] = @cube['u'][6]
    @edges[:d] = @cube['u'][3]

    #l face
    @corners[:e] = @cube['l'][0]
    @edges[:e] = @cube['l'][1]
    @corners[:f] = @cube['l'][2]
    @edges[:f] = @cube['l'][5]
    @corners[:g] = @cube['l'][8]
    @edges[:g] = @cube['l'][7]
    @corners[:h] = @cube['l'][6]
    @edges[:h] = @cube['l'][3]

    #f face
    @corners[:i] = @cube['f'][0]
    @edges[:i] = @cube['f'][1]
    @corners[:j] = @cube['f'][2]
    @edges[:j] = @cube['f'][5]
    @corners[:k] = @cube['f'][8]
    @edges[:k] = @cube['f'][7]
    @corners[:l] = @cube['f'][6]
    @edges[:l] = @cube['f'][3]

    #r face
    @corners[:m] = @cube['r'][0]
    @edges[:m] = @cube['r'][1]
    @corners[:n] = @cube['r'][2]
    @edges[:n] = @cube['r'][5]
    @corners[:o] = @cube['r'][8]
    @edges[:o] = @cube['r'][7]
    @corners[:p] = @cube['r'][6]
    @edges[:p] = @cube['r'][3]

    #b face
    @corners[:q] = @cube['b'][0]
    @edges[:q] = @cube['b'][1]
    @corners[:r] = @cube['b'][2]
    @edges[:r] = @cube['b'][5]
    @corners[:s] = @cube['b'][8]
    @edges[:s] = @cube['b'][7]
    @corners[:t] = @cube['b'][6]
    @edges[:t] = @cube['b'][3]

    #d face
    @corners[:u] = @cube['d'][0]
    @edges[:u] = @cube['d'][1]
    @corners[:v] = @cube['d'][2]
    @edges[:v] = @cube['d'][5]
    @corners[:w] = @cube['d'][8]
    @edges[:w] = @cube['d'][7]
    @corners[:x] = @cube['d'][6]
    @edges[:x] = @cube['d'][3]
  end

  #TODO: remake the scramble method
  def scramble
    scramble = ""
    before = ""
    moves = ["R", "U", "F", "L", "B", "D"]
    attributes = ["' ", "2 ", " "]
    opposite = {"R" => "L", "L" => "R", "U" => "D", "D" => "U", "F" => "B", "B" => "F"}
    30.times {
      chosen = ""
      loop do
        chosen = moves.shuffle.first
        break if chosen != before && chosen != opposite[before]
      end
      before = chosen
      chosen_attribute = attributes.shuffle.first
      scramble << chosen << chosen_attribute
    }
    puts scramble
    #self.push "L2 B2 D F2 D R2 B2 F2 D B2 L2 R' D2 F D U B D' L2 B2" #scramble
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

  def edge_buffer_in_place?
    @edges[:u] == @yellow && @edges[:k] == @green || @edges[:u] == @green && @edges[:k] == @yellow
  end

  def solve_edges
    20.times { solve_next }
    if @cube['f'][4] == @blue then push "D' L2 D M2 D' L2 D" end
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
      if edge_buffer_in_place?
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
          if @cube['f'][4] == @green
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
          if @cube['f'][4] == @green
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
          if @cube['f'][4] == @green
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
          if @cube['f'][4] == @green
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
