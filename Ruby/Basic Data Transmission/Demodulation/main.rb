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

ts = 2.0
fs = 800.0
n = (fs * ts).to_f

c = [1, 0, 1, 1, 1, 0, 1]
w = c.size.to_f
tb = (n / w).to_i

ask = []
psk = []
fsk1 = []
fsk2 = []
fsk = []

c.each_with_index do |bit, index|
  #ask
  f = n * (1.0 / tb)
  fi = 0.0
  if bit == 1
    a = 2.0
  else
    a = 0.0
  end

  ask_dt = []

  ((tb * index)...(tb * (index + 1))).each do |t|
    ask_dt << (a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))) * (1.0 * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi)))

    if ask_dt.inject(:+) > 0.1
      ask << 1
    else
      ask << 0
    end
  end

  #fsk
  i = 0
  a = 1.0
  fi = 0.0
  if bit == 1
    f = (n + 1.0) / tb

    fsk1_dt = []

    ((tb * index)...(tb * (index + 1))).each do |t|
      fsk1_dt << (a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))) * (1.0 * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi)))
      fsk1[i] = fsk1_dt.inject(:+)
      fsk2[i] = 0
      i = i + 1
    end
  else
    f = (n + 2.0) / tb

    fsk2_dt = []

    ((tb * index)...(tb * (index + 1))).each do |t|
      fsk2_dt << (a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))) * (1.0 * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi)))
      fsk2[i] = fsk2_dt.inject(:+)
      fsk1[i] = 0
      i = i + 1
    end
  end

  i.times do |j|
    if fsk1[j] - fsk2[j] > 0.1
      fsk << 1
    else
      fsk << 0
    end
  end

  #psk
  a = 1.0
  f = n * (1.0 / tb)
  if bit == 1
    fi = 0.0
  else
    fi = Math::PI
  end

  psk_dt = []

  ((tb * index)...(tb * (index + 1))).each do |t|
    psk_dt << (a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))) * (1.0 * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + 0.0)))

    if psk_dt.inject(:+) > 0.1
      psk << 1
    else
      psk << 0
    end
  end
end

gnuplot("ASK", ask)
gnuplot("ASK_spectrum", spectrum(ask.size, ask), true)
gnuplot("FSK", fsk)
gnuplot("FSK_spectrum", spectrum(fsk.size, fsk), true)
gnuplot("PSK", psk)
gnuplot("PSK_spectrum", spectrum(psk.size, ask), true)
