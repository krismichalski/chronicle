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
  xi = []

  (0..(n - 1)).each do |i|
    tmp1 = tmp2 = 0

    (0..(n-1)).each do |j|
      tmp1 += (data[j] * (Math.cos((-2 * Math::PI * j * i) / n)))
      tmp2 += (data[j] * (Math.sin((-2 * Math::PI * j * i) / n)))
    end

    xi << 10 * Math.log10(tmp1 * tmp1 + tmp2 * tmp2)
  end

  ximax = xi.max

  xi.each do |xj|
    output << xj - ximax
  end

  output
end

ts = 2
fs = 800
n = fs * ts

fm = 500
fc = 5
c = []

(0..(n - 1)).each do |t|
  c[t] = 1.0 * Math.sin((2.0 * Math::PI * fc.to_f * t.to_f) / fs.to_f)
end

(1..3).each do |subtask|
  case subtask
  when 1
    kam = 0.1
    kpm = 1.1
  when 2
    kam = 0.8
    kpm = 2.1
  when 3
    kam = 4.0
    kpm = 5.0
  end

  %w(AM PM).each do |modulation|
    data = []

    case modulation
    when 'AM'
      (0..(n - 1)).each do |t|
        data << 1.0 + (kam * c[t]) * Math.sin((2.0 * Math::PI * fm.to_f * t.to_f) / fs.to_f)
      end
    when 'PM'
      (0..(n - 1)).each do |t|
        data << 1.0 * Math.sin(((2.0 * Math::PI * fm.to_f * t.to_f) + (kpm * c[t])) / fs.to_f)
      end
    end

    gnuplot("#{modulation}_#{subtask}", data)
    gnuplot("#{modulation}_#{subtask}_spectrum", spectrum(n, data), true)
  end
end
