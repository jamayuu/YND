
class Matrix_Fomula
  def initialize(value, stream = false,size = [0,0])
    if size != [0,0] then
      if stream then
        @size = [0,0]
        @size[0] = size[1]
        @size[1] = size[0]
      else
        @size = size
      end
    else
      if stream then
        @size = [value[0].size,value.size]
      else
        @size = [value.size,value[0].size]
      end
      #printf("size:%d %d\n",@size[0],@size[1])
    end
    if stream then
      @value = Array.new(@size[0]) do
        Array.new(@size[1])
      end
      for x in 0..(@size[0] - 1) do
        for y in 0..(@size[1] - 1) do
          if value[y][x].class == Term || value[y][x].class == Fomula then
            @value[x][y] = value[y][x].ret
          else
            @value[x][y] = (value[y][x].to_i == value[y][x]) ? (value[y][x].to_i) : (value[y][x])
          end
        end
      end
    else
      @value = Array.new(@size[0]) do
        Array.new(@size[1])
      end
      for x in 0..(@size[0] - 1) do
        for y in 0..(@size[1] - 1) do
          if value[x][y].class == Term || value[x][y].class == Fomula then
            @value[x][y] = value[x][y].ret
          else
            @value[x][y] = (value[x][y].to_i == value[x][y]) ? (value[x][y].to_i) : (value[x][y])
          end
        end
      end
    end
  end

  def ret()
    return Matrix_Fomula.new(@value)
  end

  def value()
    return @value
  end

  def size()
    return @size
  end

  def insert(x,y,value)
    if value.class == Term || value.class == Fomula then
      @value[x][y] = value.ret
    else
      @value[x][y] = value
    end
  end

  def insert_value(value)
    ret = Array.new(@size[0]) do
      Array.new(@size[1])
    end
    for x in 0..(@size[0] - 1) do
      for y in 0..(@size[1] - 1) do
        if @value[x][y].class == Term || @value[x][y].class == Fomula then
          ret[x][y] = @value[x][y].insert_value(value)
        else
          ret[x][y] = @value[x][y]
        end
      end
    end
    return Matrix_Fomula.new(ret)
  end

  def insert_stream(value)
    for x in 0..(size[0] - 1) do
      for y in 0..(size[1] - 1) do
        @value[x][y] = value[y][x]
      end
    end
  end

  def insert_matrix(mat)
    for x in 0..(@size[0] - 1) do
      for y in 0..(@size[1] - 1) do
        insert(x,y,mat[x][y])
      end
    end
  end

  def -@
    ret = Array.new(@size[0]) do
      Array.new(@size[1])
    end
    for x in 0..(@size[0] - 1) do
      for y in 0..(@size[1] - 1) do
        ret[x][y] = -(@value[x][y])
      end
    end
    return ret
  end

  def +(other)
    if @size != other.size then
      return nil
    end
    ret = Array.new(@size[0]) do
      Array.new(@size[1])
    end
    for x in 0..(@size[0] - 1) do
      for y in 0..(@size[1] - 1) do
        if @value[x][y].class == Term || @value[x][y].class == Fomula then
          ret[x][y] = @value[x][y] + other.value[x][y]
        else
          ret[x][y] = other.value[x][y] + @value[x][y]
        end
      end
    end
    return Matrix_Fomula.new(ret)
  end

  def -(other)
    if @size != other.size then
      return nil
    end
    ret = Array.new(@size[0]) do
      Array.new(@size[1])
    end
    for x in 0..(@size[0] - 1) do
      for y in 0..(@size[1] - 1) do
        if @value[x][y].class == Term || @value[x][y].class == Fomula then
          ret[x][y] = @value[x][y] - other.value[x][y]
        else
          ret[x][y] = -other.value[x][y] + @value[x][y]
        end
      end
    end
    return Matrix_Fomula.new(ret)
  end

  def *(other)
    if other.class == Matrix_Fomula then
      if @size[0] != other.size[1] then
        return nil
      else
        size = [other.size[0],@size[1]]
        ret = Array.new(size[0]) do
          Array.new(size[1],Fomula.new())
        end
        for x in 0..(size[0] - 1) do
          for y in 0..(size[1] - 1) do
            for n in 0..(@size[0] - 1) do
              ret[x][y] += Math_Matrix.multi(@value[n][y],other.value[x][n])
            end
          end
        end
      end
    else
      ret = Array.new(@size[0]) do
        Array.new(@size[1],Fomula.new())
      end
      for x in 0..(@size[0] - 1) do
        for y in 0..(@size[1] - 1) do
          ret[x][y] = Math_Matrix.multi(@value[x][y],other)
        end
      end
    end
    return Matrix_Fomula.new(ret)
  end

  def ==(other)
    if other.class == Matrix_Fomula then
      if @size != other.size then
        return false
      else
        for x in 0..(@size[0] - 1) do
          for y in 0..(@size[1] - 1) do
            #if other.value[x][y] ==
          end
        end
      end
    else
      return false
    end
  end

  def out_all(width = 8)
    max = width
    str = Array.new(@size[0]) do
      Array.new(@size[1],"")
    end
    for x in 0..(@size[0] - 1) do
      for y in 0..(@size[1] - 1) do
        str[x][y] = (@value[x][y]).to_s
        if max < str[x][y].size then max = str[x][y].size end
      end
    end
    format = "%-" + max.to_s + "s, "
    for y in 0..(@size[1] - 1) do
      for x in 0..(@size[0] - 1) do
        printf(format,str[x][y])
      end
      printf("\n")
    end
    printf("\n")
  end

  def out(x,y)
    printf("%s\n",(@value[x][y]).to_s)
  end
end

class Math_Matrix
  #y1にy2を加算する
  def self.line_add(mat,y1,y2,multi = 1)
    for x in 0..(mat.size[0] - 1) do
      mat.insert(x,y1,mat.value[x][y1] + mat.value[x][y2] * multi)
    end
  end

  def self.line_multi(mat,y,value)
    for x in 0..(mat.size[0] - 1) do
      mat.insert(x,y,mat.value[x][y] * value)
    end
  end

  def self.line_swap(mat,y1,y2)
    for x in 0..(mat.size[0] - 1) do
      dump = mat.value[x][y2]
      mat.insert(x,y2,mat.value[x][y1])
      mat.insert(x,y1,dump)
    end
  end

  def self.add(x,y)
    if x.class != Term && x.class != Fomula then
      return (y + x)
    else
      return (x + y)
    end
  end

  def self.multi(x,y)
    if x.class != Term && x.class != Fomula then
      return (y * x)
    else
      return (x * y)
    end
  end

  def self.line_sort(mat)
    #ret = Matrix_Fomula.new(mat.value)
    dump_ary = Array.new(mat.size[1],0)

    for y in 0..(mat.size[1] - 1) do
      for x in 0..(mat.size[0] - 1) do
        if (mat.value[x][y].class != Term && mat.value[x][y].class != Fomula) then
          dump_ary[y] += ((mat.value[x][y] != 0) ? (1 << (mat.size[0] - x - 1)) : 0)
        end
      end
    end

    for n in 0..(dump_ary.size - 2) do
      for m in 0..(dump_ary.size - 2 - n) do
        if dump_ary[m] < dump_ary[m+1] then
          dump = dump_ary[m]
          dump_ary[m] = dump_ary[m+1]
          dump_ary[m+1] = dump
          #Math_Matrix.line_swap(ret,m,m+1)
          Math_Matrix.line_swap(mat,m,m+1)
        end
      end
    end
  end

  def self.chain(mat1,mat2)
    if mat1.size[1] != mat2.size[1] then
      return nil
    else
      num = Array.new(mat1.size[0] + mat2.size[0]) do
        Array.new(mat1.size[1])
      end

      for x in 0..(mat1.size[0] + mat2.size[0] - 1) do
        for y in 0..(mat1.size[1] - 1) do
          if x < mat1.size[0] then
            num[x][y] = mat1.value[x][y]
          else
            num[x][y] = mat2.value[x - mat1.size[0]][y]
          end
        end
      end
      ret = Matrix_Fomula.new(num)
      return ret
    end
  end

  def self.simp(mat,reves = false)
    ret = mat.ret
    size = [ret.size[0],ret.size[1]]
    for y in 0..(size[1] - 1) do
      for x in 0..(size[0] - 1) do
        if ret.value[x][y].class == Term && ret.value[x][y].class == Term then
          ret.insert(x,y,0)
        end
      end
    end
    ret = Math_Matrix.chain(ret,Math_Matrix.normal(ret.size[1]))
    for y in 0..(ret.size[1] - 1) do
      Math_Matrix.line_sort(ret)
      for x in 0..(ret.size[0] - 1) do
        if ret.value[x][y] != 0 then
          Math_Matrix.line_multi(ret,y,1.quo(ret.value[x][y]))
          for y2 in 0..(ret.size[1] - 1) do
            if y != y2 then
              Math_Matrix.line_add(ret,y2,y,-ret.value[x][y2])
            end
          end
          break
        end
      end
    end
    rev = Matrix_Fomula.new(ret.value[(size[0])..(size[0] + size[1])])
    if reves then
      return rev
    else
      return rev * mat
    end
  end

  def self.normal(size)
    ret = Array.new(size) do
      Array.new(size,0)
    end
    for n in 0..(size - 1) do
      ret[n][n] = 1
    end
    return Matrix_Fomula.new(ret)
  end

end
