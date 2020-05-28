=begin
行列と多項式をいい感じに演算できるライブラリを作ろう
数値の概念を拡張する

数(項)は配列で扱い、[係数,次数]で表す
[5,[1,2,3]] = 5 * a * b^2 * c^3

式は配列で扱い[項(Term)]で表す

記号は最初に何種類、またどんな文字をあるかを調べ、リスト化する。
その後それらの文字を複合して使用する。

クラス:
数値の形
これらの数値の形を利用した行列の形
基本的に数値は全てrational(分数)オブジェクトで扱う

関数:
文字列を上記の形に直す関数
上記の数の四則演算(除算は除く)
上記を用いた行列同士の四則演算(除算は除く)

=end

$type = []

class Term
  def initialize(coef = 0,degr = Array.new($type.size,0))
    @coef = coef
    if coef == 0 then
      @degr =  Array.new($type.size,0)
    else
      @degr = []
      degr.each{|x| @degr.push(x)}
    end
    @dim = 0
    if @degr.size != 0 then
      for n in 0..(@degr.size - 1) do
        @dim += @degr[n]
      end
    end
    if @coef.to_i == @coef then
      @coef = @coef.to_i
    end
  end

  def out(new_line = true)
    if self.to_s.index(" ") == nil then
      printf("%s",self.to_s)
    else
      printf("(%s)",self.to_s)
    end
    if new_line then printf("\n") end
  end

  def to_s()
    ret = ""
    if @degr == Array.new($type.size,0) then
      return @coef.to_s
    elsif @coef != 0 then
      if @coef != 1 then ret = ret + @coef.to_s end
      for n in 0..(@degr.size - 1) do
        if @degr[n] != 0 then
          if @degr[n] == 1 then
            ret = ret + $type[n]
          else
            ret = ret + $type[n] + "^" + @degr[n].to_s
          end
          if n != (@degr.size - 1) then
            if @degr[(n+1)..(@degr.size - 1)] != Array.new($type.size - 1 - n,0) then
              ret = ret +  " "
            else
              break
            end
          end
        end
      end
    else
      ret = "0"
    end
    return ret
  end

  def ret()
    return Term.new(@coef,@degr)
  end

  def coef()
    return @coef
  end

  def degr()
    return @degr
  end

  def dim()
    return @dim
  end

  def in_coef(value)
    @coef = value
  end

  def in_degr(value)
    @degr = value
  end

  def insert_value(value)
    ret = Term.new(@coef)
    for n in 0..($type.size - 1) do
      ret = ret * (value[n] ** @degr[n])
    end
    return Term.new(ret.coef,ret.degr)
  end

  def -@
    return Term.new(-@coef,@degr)
  end

  def +(other)
    if other.class == Term then
      return Fomula.new([self,other])
    elsif other.class == Fomula then
      return other + self
    else
      return Fomula.new([self,Term.new(other)])
    end
  end

  def -(other)
    if other.class == Term then
      return Fomula.new([self,-other])
    elsif other.class == Fomula then
      return -other + self
    else
      return Fomula.new([self,Term.new(-other)])
    end
  end

  def *(other)
    if other.class == Term then
      coef = @coef * other.coef()
      degr = []
      for n in 0..($type.size - 1) do
        degr.push(@degr[n] + other.degr()[n])
      end
      return Term.new(coef,degr)
    elsif other.class == Fomula then
      return other * Fomula.new([self])
    else
      coef = @coef * other
      return Term.new(coef,@degr)
    end
  end

  def **(other)
    coef = @coef ** other
    degr = []
    for n in 0..($type.size - 1) do
      degr.push(@degr[n] * other)
    end
    return Term.new(coef,degr)
  end

  def /(other)
    if other.class == Term then
      if other.coef() == 0 then
        return Term.new()
      end
      for n in 0..($type.size - 1) do
        if @degr[n] < other.degr()[n] then
          return Term.new()
        end
      end
      coef = @coef.quo(other.coef())
      degr = []
      for n in 0..($type.size - 1) do
        degr.push(@degr[n] - other.degr()[n])
      end
      return Term.new(coef,degr)
    else
      return Term.new(@coef.quo(other),@degr)
    end
  end

  def <=>(other)
    if @degr == other.degr() then
      if @coef == other.coef() then
        return 0
      elsif @coef < other.coef() then
        return -1
      else
        return 1
      end
    elsif @dim != other.dim() then
      return (@dim <=> other.dim())
    else
      for n in 0..($type.size - 1) do
        if @degr[n] != other.degr()[n] then
          return (@degr[n] <=> other.degr()[n])
        end
      end
    end
  end

  def ==(other)
    if other.class == Term then
      return (@degr == other.degr() && @coef == other.coef())
    elsif other.class == Fomula then
      return (other.value.size == 1 && self == other.value[0])
    else
      return (@coef == other && @degr == Array.new($type.size,0))
    end
  end

end

class Fomula
  def initialize(value = [Term.new(0)])
    @value = []
    value.each{|x|
      if x.class == Term then
        @value.push(x.ret())
      else
        @value.push(Term.new(x))
      end
    }
    if @value.size() != 0 then
      for n in 0..(@value.size-1) do
        for m in (n+1)..(@value.size-1) do
          if (@value[m].degr() == @value[n].degr()) then
            @value[n].in_coef(@value[n].coef() + @value[m].coef())
            @value[m].in_coef(0)
          end
        end
      end
      @value.delete_if{|x| x.coef() == 0}
      @value.sort!.reverse!
      if @value[0].class != Term then
        @dim = 0
      else
        @dim = @value[0].dim()
      end
    else
      @dim = 0
    end
  end

  def value()
    return @value
  end

  def dim()
    return @dim
  end

  def ret()
    return Fomula.new(@value)
  end

  def sort()
    @value.delete_if{|x| x.coef() == 0}
    @value.sort!.reverse!
    @dim = @value[0].dim()
  end

  def out()
    printf("%s\n",self.to_s)
  end

  def to_s()
    ret = ""
    if @value.size == 0 then
      return "0"
    elsif @value.size == 1 then
      if @value[0].class == Term then
        if @value[0].to_s.index(" ") == nil then
          ret = @value[0].to_s
        else
          ret = "(" + @value[0].to_s + ")"
        end
      else
        ret = @value[0].to_s
      end
    else
      for n in 0..(@value.size-1) do
        if @value[n].to_s.index(" ") == nil then
          ret = ret + @value[n].to_s()
        else
          ret = ret + "(" + @value[n].to_s() + ")"
        end
        if n != (@value.size - 1) then ret = ret + " + " end
      end
    end
    return ret
  end

  def insert_value(value)
    ret = Fomula.new()
    for n in 0..(@value.size - 1) do
      ret += @value[n].insert_value(value)
    end
    return Fomula.new(ret.value)
  end

  def -@
    ret = []
    @value.each do |x|
      ret.push(-x)
    end
    return Fomula.new(ret)
  end

  def +(other)
    if other.class == Fomula then
      return Math_Fomula.add(self,other)
    elsif other.class == Term then
      return Math_Fomula.add(self,Fomula.new([other]))
    else
      return Math_Fomula.add(self,Fomula.new([Term.new(other)]))
    end
  end

  def -(other)
    if other.class == Fomula then
      return Math_Fomula.sub(self,other)
    elsif other.class == Term then
      return Math_Fomula.sub(self,Fomula.new([other]))
    else
      return Math_Fomula.sub(self,Fomula.new([Term.new(other)]))
    end
  end

  def *(other)
    if other.class == Fomula then
      return Math_Fomula.multi(self,other)
    elsif other.class == Term then
      return Math_Fomula.multi(self,Fomula.new([other]))
    else
      return Math_Fomula.multi(self,Fomula.new([Term.new(other)]))
    end
  end

  def /(other)
    if other.class == Fomula then
      return Math_Fomula.div(self,other)
    elsif other.class == Term then
      return Math_Fomula.div(self,Fomula.new([other]))
    else
      return Math_Fomula.div(self,Fomula.new([Term.new(other)]))
    end
  end

  def **(other)
    return Math_Fomula.expl(self,other)
  end

  def ==(other)
    if other.class == Fomula then
      if @value.size() != other.value().size() then
        return false
      else
        for n in 0..(@value.size() - 1) do
          if @value[n] != other.value()[n] then
            return false
          end
        end
      end
      return true
    elsif other.class == Term then
      return (other == self)
    else
      return (Term.new(other) == self)
    end
  end

  def <=>(other)
    if self == other then
      return 0
    elsif @value.size() != other.value().size() then
      return @value.size() <=> other.value().size()
    elsif @dim != other.dim() then
      return (@dim <=> other.dim())
    else
      for n in 0..(@value.size() - 1) do
        if (@value[n] <=> other.value()[n]) == 1 then
          return 1
        end
      end
      return -1
    end
  end

end

class Math_Fomula
  def self.add(f1,f2)
      return Fomula.new(f1.value() + f2.value())
  end

  def self.sub(f1,f2)
    return Fomula.new(f1.value() + (-f2).value())
  end

  def self.multi(f1,f2)
    ret = []
    if f2.class != Fomula then
      for n in 0..(f1.value().size - 1) do
        ret.push(f1.value()[n] * f2)
      end
    else
      for n in 0..(f1.value().size - 1) do
        for m in 0..(f2.value().size - 1) do
          ret.push(f1.value()[n] * f2.value()[m])
        end
      end
    end
    return Fomula.new(ret)
  end

  def self.div(f1,f2)
    ret = Fomula.new()
    dump = Fomula.new(f1.value())
    while (dump.value().size() != 0) do
      ans = (dump.value()[0] / f2.value()[0])
      dump = dump - (ans * f2)
      ret = ret + ans
      #printf("ret:");ret.out()
      #printf("dump:");dump.out()
    end
    return ret
  end

  def self.expl(f1,value)
    if value == 0 then
      return 1
    else
      ret = f1.ret()
      (value - 1).times do
        ret = Math_Fomula.multi(f1,ret)
      end
    end
    return ret
  end
end
