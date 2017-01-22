def gnuplot(filename, data, spectrum = false)
  data_size = data.size

  if spectrum
    data_size = data_size / 2
  end

  commands = %Q(
    set terminal svg size 1024,768
    set offset graph 0.1, graph 0.1, graph 0.1, graph 0.1
    set output "#{filename}.svg"
    set xrange [0:#{data_size}]
    plot "-" with lines notitle
  )

  data.each_with_index do |y, x|
    commands << x.to_s + " " + y.to_s + "\n"
  end
  commands << "e\n"

  IO.popen("gnuplot", "w") { |io| io.puts commands }
end

def spectrum(n, data)
  output = []

  (0..(n - 1)).each do |i|
    tmp1 = tmp2 = 0

    (0..(n-1)).each do |j|
      tmp1 += (data[j] * (Math.cos((-2 * Math::PI * j * i) / n)))
      tmp2 += (data[j] * (Math.sin((-2 * Math::PI * j * i) / n)))
    end

    output << Math.sqrt(tmp1 * tmp1 + tmp2 * tmp2)
  end

  output
end

# Wave 1
fi = Math::PI / 2
ts = 2
a = 0.5
f = 15
fs = 800
n = fs * ts

data = []

(0..(n - 1)).each do |t|
  data << a * Math.sin(2 * Math::PI * f * t / fs + fi)
end

gnuplot("Wave1", data)
gnuplot("Wave1_spectrum", spectrum(n, data), true)

# Wave 2
fs = 3500
ts = 2.5
n = fs * ts
z = [0]

(0..(n - 1)).each do |t|
  if(t <= n / 4)
    z[t + 1] = z[t] + (0.5 / (n / 4))
  elsif(t > n / 4 && t <= n / 2)
    z[t + 1] = z[t] - (0.5 / (n / 4))
  elsif(t > n / 2 && t <= 3 * (n / 4))
    z[t + 1] = z[t] + (0.5 / (n / 4))
  elsif(t > 3 * (n / 4))
    z[t + 1] = z[t] - (0.5 / (n / 4))
  end
end

(1..3).each do |subtask|
  data = []

  case subtask
  when 1
    f1 = 50
    f2 = 36
  when 2
    f1 = 36
    f2 = 50
  when 3
    f1 = f2 = 36
  end

  w1 = 2 * Math::PI * f1
  w2 = 2 * Math::PI * f2

  (0..(n - 1)).each do |t|
    data << z[t] * Math.sin((w1 * t) / fs) * Math.cos((w2 * t) / fs)
  end

  gnuplot("Wave2_#{subtask}", data)
  gnuplot("Wave2_#{subtask}_spectrum", spectrum(n, data), true)
end

# Wave 3
fs = 3500
ts = 2.5
n = fs * ts

(1..3).each do |subtask|
  data = []

  case subtask
  when 1
    ka = 10
  when 2
    ka = 20
  when 3
    ka = 30
  end

  f = 15.0

  (0..(n - 1)).each do |t|
    sum = 0.0

    (1..ka).each do |k|
      sum += (1.0 / (2.0 * k.to_f - 1.0)) * Math.sin(((2.0 * k.to_f - 1.0) * f * t.to_f) / fs.to_f)
    end

    data << (4.0 / Math::PI) * sum
  end

  gnuplot("Wave3_#{subtask}", data)
  gnuplot("Wave3_#{subtask}_spectrum", spectrum(n, data), true)
end
