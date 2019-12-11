require_relative 'Library/class.rb'
#試しにf(a,b,c) = 10a^2 + 5b + c + 2 になるようなデータセットを作りどのくらい近似できるかやってみる。
#
test = Network.new(4,[3,5,3,1],10)

answers = []
datasets = []
num = 100
limit = 20

for n in 0..(num - 1) do
  datasets.push(
    Array.new(3) do
      rand(limit)
    end
  )
  answers.push(Array.new(1,0))
  answers[n][0] += 10 * (datasets[n][0] ** 2) + 5 * datasets[n][1] + datasets[n][2] + 2
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
test.accuracy(datasets,answers)
