require_relative 'Library/class.rb'
#試しにf(a,b,c) = a + b + 2c になるようなデータセットを作りどのくらい近似できるかやってみる。
#
test = Network.new(2,[3,1],3)

answers = []
datasets = []
num = 100

for n in 0..(num - 1) do
  datasets.push(
    Array.new(3) do
      rand(num)
    end
  )
  answers.push(Array.new(1,0))
  answers[n][0] += datasets[n][0] + datasets[n][1] + 2*datasets[n][2]
end

puts("datasets:")
p datasets
puts("\n")
puts("answers:")
p answers
puts("\n")

=begin
test.inrelations([[[1], [1], [2]]])
test.outans([1,1,1])
test.accuracy(datasets,answers)
=end

test.learn(1000,answers,datasets)
puts("calculated relation:")
test.outrelation
puts("\n")

test.outans([1,1,1])
test.accuracy(datasets,answers)
