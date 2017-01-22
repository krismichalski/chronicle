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

# Wave1
ts = 2.0
fs = 800.0
n = (fs * ts).to_f

c = [1, 0, 1, 1, 1, 0, 1]
w = c.size.to_f
tb = (n / w).to_i

ask1 = []
ask2 = []
fsk = []
psk = []

c.each_with_index do |bit, index|
  #ask1
  f = n * (1.0 / tb)
  fi = 0.0
  if bit == 1
    a = 2.0
  else
    a = 0.0
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    ask1 << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end

  #ask2
  f = n * (1.0 / tb)
  fi = 0.0
  if bit == 1
    a = 2.0
  else
    a = 1.0
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    ask2 << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end

  #fsk
  a = 1.0
  fi = 0.0
  if bit == 1
    f = (n + 1.0) / tb
  else
    f = (n + 2.0) / tb
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    fsk << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end

  #psk
  a = 1.0
  f = n * (1.0 / tb)
  if bit == 1
    fi = 0.0
  else
    fi = Math::PI
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    psk << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end
end

gnuplot("Wave1_ask1", ask1)
gnuplot("Wave1_ask1_spectrum", spectrum(ask1.size, ask1), true)
gnuplot("Wave1_ask2", ask2)
gnuplot("Wave1_ask2_spectrum", spectrum(ask2.size, ask2), true)
gnuplot("Wave1_fsk", fsk)
gnuplot("Wave1_fsk_spectrum", spectrum(fsk.size, fsk), true)
gnuplot("Wave1_psk", psk)
gnuplot("Wave1_psk_spectrum", spectrum(psk.size, psk), true)

# Wave2
ts = 1.0
fs = 3600.0
n = (fs * ts).to_f

string = "he has dog"
c = string.unpack('c*').map {|e| e.to_s(2).split('').map(&:to_i) }.flatten
w = c.size.to_f
tb = (n / w).to_i

ask1 = []
ask2 = []
fsk = []
psk = []

c.each_with_index do |bit, index|
  #ask1
  f = n * (1.0 / tb)
  fi = 0.0
  if bit == 1
    a = 2.0
  else
    a = 0.0
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    ask1 << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end

  #ask2
  f = n * (1.0 / tb)
  fi = 0.0
  if bit == 1
    a = 2.0
  else
    a = 1.0
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    ask2 << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end

  #fsk
  a = 1.0
  fi = 0.0
  if bit == 1
    f = (n + 1.0) / tb
  else
    f = (n + 2.0) / tb
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    fsk << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end

  #psk
  a = 1.0
  f = n * (1.0 / tb)
  if bit == 1
    fi = 0.0
  else
    fi = Math::PI
  end

  ((tb * index)...(tb * (index + 1))).each do |t|
    psk << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
  end
end

gnuplot("Wave2_ask1", ask1)
gnuplot("Wave2_ask1_spectrum", spectrum(ask1.size, ask1), true)
gnuplot("Wave2_ask2", ask2)
gnuplot("Wave2_ask2_spectrum", spectrum(ask2.size, ask2), true)
gnuplot("Wave2_fsk", fsk)
gnuplot("Wave2_fsk_spectrum", spectrum(fsk.size, fsk), true)
gnuplot("Wave2_psk", psk)
gnuplot("Wave2_psk_spectrum", spectrum(psk.size, psk), true)
