require "./lib/poly_lib.rb"
require "./lib/mat_lib.rb"

=begin
このライブラリでは、それぞれ、多項式と、行列の演算に関するクラスを追加します。
基本的に四則演算(割り算を除く)は普通に行えます(式 * 単項、行列 * 行列など)
一応単項同士や、式同士の割り算も用意されてはいますが、めちゃくちゃなため、使わないことをおすすめします。
式や、単項を実数で割りたい場合には (式、または単項) * (1.quo(実数)) と書くことをおすすめします。float型の数字なんかをかけてもいいですが、分数にしておくと簡約化などを行った時に不具合が減ると思います。
注意として、[クラスのメソッド (二項演算子) 実数]という演算は可能ですが、[実数 (二項演算子)　クラスのメソッド]はRubyの性質上できません。
要するに、 F * 5や、F + 1はできますが、5 * Fや、 1 + Fはできません。
またここでは、RubyのArrayである配列と、今回のクラスのもつMatrix_Fomulaである行列は言葉を使い分けています。
=end


#変数の種類を決定します。$typeはいろいろなところで使ってしまっているの名前をかえたりしないでください
$type = ["x","y"]

#単項を作成します
#Term.new(係数,[変数1の次数,変数2の次数,...])
x = Term.new(1,[1,0])
y = Term.new(1,[0,1])

#式を作成します
#Fomula.new([単項1,単項2,...])、一応式の構成に単項の代わりに式を入れることも可能です。
f1 = Fomula.new([x,y,1])
f2 = f1**3

#式、単項を表示します
printf("x = ");x.out()
printf("f1 = ");f1.out()
printf("f2 = f1 ** 3 = ");f2.out()

#おまけ機能: 式、単項は .to_s に対応していて、文字列に変換できます。
f3 = f1 + x + y**3
printf("f3 = %s\n",f3.to_s)

#行列を作る元となる配列を作成します
m1 = [
  [0,1,1,0],
  [0,1,1,2],
  [2,0,1,4],
  [5,5,0,1]
]

m2 = [
  [0,1,0,0],
  [0,1,0,0],
  [0,1,1,x],
  [y,x,3,6]
]


#行列を作成します
#Matrix_Fomula.new(配列,true)
#ここのtrueはこの行列では、mat1[x][y]というふうに値が構成されるため、上のような配列とは見た目上のx,y座標が反転します。反転していれるか否かがここで判別されます。よくわからなければ基本trueで大丈夫です。うまくいかなかったらfalseにしてみてください。
mat1 = Matrix_Fomula.new(m1,true)
mat2 = Matrix_Fomula.new(m2,true)

printf("\n")

#行列を表示します
printf("mat1:\n");mat1.out_all()
printf("mat2:\n");mat2.out_all()

#行列の中身にアクセスします、Matrix_Fomula(行列).value は中身の二次元の行列を返します。
#配列の中身は様々な型が存在する可能性がありますが、全て to_s に対応しているため、表示するならばこうするのがおすすめです。
printf("mat1[0][0]:%s\n",mat1.value[0][0].to_s)

#要素の一つを変更したい場合 mat1.insert(x,y,値)
printf("mat1[0][0] -> 5\n");mat1.insert(0,0,5)

#単純に要素の一つを表示したい場合
#mat1.out(x,y)
printf("mat1[0][0]:");mat1.out(0,0)

printf("\n")

#上記の仕様を利用して、簡単に転置行列が作れます。
mat1_trans = Matrix_Fomula.new(mat1.value,true)
printf("mat1_trans:\n");mat1_trans.out_all()

#mat1 の右に　mat2　を連結したものを返します。非破壊的です(mat1とmat2には影響がありません)。
#サイズの問題が生じた場合はnilが返ります。
mat3 = Math_Matrix.chain(mat1,mat2)
printf("mat1:mat2\n");mat3.out_all()

#mat1を簡約化したものを返します。この時、変数を含むものは無視して簡約化が行われます。非破壊的
mat4 = Math_Matrix.simp(mat1)
printf("mat1の簡約化:\n");mat4.out_all()

#mat1を簡約化する際の P * mat1 = mat1_simpの Pを返します。非破壊的
mat5 = Math_Matrix.simp(mat1,true)
printf("P * mat1 = mat1の簡約化の P:\n");mat5.out_all()

#式や、行列をそのままスカラー倍できます
printf("P * 85:\n");(mat5 * 85).out_all

#行列同士は足し引き掛け算が可能で、サイズの問題が生じた場合はnilが返ります。
#なお足し引きはサイズが同じでないと行えません
mat6 = mat1 * mat2
printf("mat1 * mat2:\n");mat6.out_all()

#行列や式、単項に対して変数に値を代入します。(行列、式など).insert_value([変数1の値、変数2の値...])
#単項も入力することができます。
#代入した結果を元のものと同じ型で返します。非破壊的
printf("mat1 * mat2:(x = 3,y = 2)\n");mat6.insert_value([3,2]).out_all()
printf("f1:(x = x,y = 2): ");f1.insert_value([x,2]).out()

#正規行列を生成します:Math_Matrix(サイズ)
normal = Math_Matrix.normal(5)
printf("5 * 5の正規行列\n");normal.out_all
