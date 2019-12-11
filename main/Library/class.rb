class Relations
  #関係は、方向、重さ 0 ~ limitで定まる
  def initialize(depth,width,limit = 100)
    @depth = depth
    @width = width
    @limit = limit
    #relations[depth,number,direction]である
    @relations = Array.new(@depth - 1)
    for n in 0..(@depth - 2) do
      @relations[n] = Array.new(@width[n]) do
        Array.new(@width[n+1],0)
      end
    end
  end

  def randomize
    for n in 0..(@depth - 2) do
      for m in 0..(@width[n]-1) do
        for k in 0..(@width[n+1]-1) do
          @relations[n][m][k] = rand((2 * @limit)) - @limit
        end
      end
    end
  end

  def input(relations)
    @relations = relations
  end

  def ent
    return @relations
  end
end

class Materials
  def initialize(depth,width,relations)
    @relations = relations
    @depth = depth
    @width = width
    @score = Array.new(@depth)
    for n in 0..(@depth - 1) do
      @score[n] = Array.new(@width[n],0)
    end
  end

  def reflect(depth,number,direction)
    return @score[depth][number] * @relations.ent[depth][number][direction]
  end

  def add(depth,number,input)
    @score[depth][number] += input
  end

  def score
    return @score
  end
end

class Network
  def initialize(depth,width,limit)
    #result[]
    @depth = depth
    @width = width
    @limit = limit
    #result[ベストの関係、最終結果の解答との差の合計]
    @result = [Relations.new(@depth,@width),0]
    @relations = Relations.new(@depth,@width,@limit)
    @differs = []
    @best = Marshal.load(Marshal.dump(@relations))
  end

  #関係の重みをランダムにする
  def randomize
    @relations.randomize
  end

  #実際にデータを用いて、今の重みで演算する。
  #dataは長さが最初のシナプスの数である配列
  def calculate(data)
    #printf("score:%s\n", @materials.score)
    materials = Materials.new(@depth,@width,@relations)
    for n in 0..(@width[0] - 1) do
      materials.add(0,n,data[n])
    end

    for n in 0..(@depth - 2) do
      for m in 0..(@width[n+1] - 1) do
        for k in 0..(@width[n] - 1) do
          materials.add(n+1,m,materials.reflect(n,k,m))
        end
      end
    end

    return materials.score
  end

  #学習する
  def learn(timenum,answers,datasets)
    mindiffer = -1
    timenum.times do
      randomize()
      differ = 0
      for n in 0..(answers.length - 1)
        for m in 0..(@width[@depth - 1] - 1) do
          differ += (calculate(datasets[n])[@depth - 1][m] - answers[n][m]).abs
        end
      end
      #printf("calc:%s\n" ,calculate(datasets[n])[@depth - 1][m])
      @differs.push(differ)
      if mindiffer == -1 then
        mindiffer = differ
      elsif differ == 0
        @best = Marshal.load(Marshal.dump(@relations))
        break
      elsif mindiffer > differ then
        mindiffer = differ
        @best = Marshal.load(Marshal.dump(@relations))
      end
      #p mindiffer
    end
  end

  #外部から関係を読み込む
  def inrelations(relations)
    @relations.input(relations)
  end

  def outrelation
    p @best.ent
  end

  def outans(data)
    @relations = Marshal.load(Marshal.dump(@best))
    puts("differs")
    p @differs
    puts("input:")
    p data
    puts("output:")
    p calculate(data)
    puts("\n")
  end

  def accuracy(datasets,answers)
    @relations = Marshal.load(Marshal.dump(@best))
    differ = 0
    ans = 0
    for n in 0..(answers.length - 1)
      for m in 0..(@width[@depth - 1] - 1) do
        differ += (calculate(datasets[n])[@depth - 1][m] - answers[n][m]).abs
        ans += answers[n][m]
      end
    end
    puts("average differ:")
    p (differ.to_f/(answers.length.to_f * @width[@depth - 1]))
    puts("average answers:")
    p (ans.to_f/(answers.length.to_f * @width[@depth - 1]))
    printf("的中率(ave differ/ave answers): \n%f%%",(differ.to_f/ans) * 100.0
    )
    puts("\n")
  end

end

#test = Network.new(3,[3,2,1])
