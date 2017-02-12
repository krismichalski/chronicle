require "shoes" #v4.0.0.pre8

Shoes.app title: "Basic Data Transmission", width: 800, height: 600 do

  fi = nil
  ts = nil
  a = nil
  f = nil
  fs = nil
  f1 = nil
  f2 = nil
  ka = nil
  fm = nil
  fc = nil
  kam = nil
  kpm = nil
  text = nil
  c = nil
  bits = nil
  broke = nil

  stack margin: 10 do

    stack do
      subtitle "Basic Data Transmission"
      tagline "GUI"
    end

    flow do
      labs = {
        lab1: "Simple Waves",
        lab3: "Analog Modulation",
        lab4: "Digital Modulation",
        lab5: "Demodulation",
        lab6: "Hamming Error Correction"
      }

      labs.each do |key, value|
        s = stack width: 156, margin_top: 10, margin_bottom: 10 do
          background system_background
          image "images/#{key.to_s}.png", left: 28
          para value, align: "center", top: 105

          hover do
            s.clear do
              background aliceblue
              image "images/#{key.to_s}.png", left: 28
              para value, align: "center", top: 105
            end
          end

          leave do
            s.clear do
              background system_background
              image "images/#{key.to_s}.png", left: 28
              para value, align: "center", top: 105
            end
          end
        end
        s.click do
          labs.keys.each do |other_key|
            next if other_key == key
            eval(other_key.to_s).hide
          end
          eval(key.to_s).toggle
          eval("lab1_zad1").hide
          eval("lab1_zad2").hide
          eval("lab1_zad3").hide
          eval("lab3_am").hide
          eval("lab3_pm").hide
          eval("lab4_zad1").hide
          eval("lab4_zad2").hide
          eval("lab5_zad1").hide
          eval("lab6_zad1").hide
        end
      end
    end

    ### LAB1 ###

    lab1 = stack hidden: true, margin_top: 10 do
      subtitle "Simple Waves"

      flow margin_top: 10 do
        button "Task1", margin_left: 15 do |b|
          b.click do
            eval("lab1_zad1").toggle
            eval("lab1_zad2").hide
            eval("lab1_zad3").hide
          end
        end
        button "Task2", margin_left: 15 do |b|
          b.click do
            eval("lab1_zad1").hide
            eval("lab1_zad2").toggle
            eval("lab1_zad3").hide
          end
        end
        button "Task3", margin_left: 15 do |b|
          b.click do
            eval("lab1_zad1").hide
            eval("lab1_zad2").hide
            eval("lab1_zad3").toggle
          end
        end
      end
    end

    lab1_zad1 = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "fi: ", top: 7
            fi = edit_line width: 150, margin_left: 50
            fi.text = "PI / 2"
          end
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "2"
          end
          flow margin_top: 5 do
            para "a: ", top: 7
            a = edit_line width: 150, margin_left: 50
            a.text = "0.5"
          end
          flow margin_top: 5 do
            para "f: ", top: 7
            f = edit_line width: 150, margin_left: 50
            f.text = "15"
          end
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "800"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          flow { spectrum = check; para "Spectrum?" }
          button "START" do |b|
            b.click do
              func_lab1_zad1(fi, ts, a, f, fs, spectrum.checked?)
            end
          end
        end
      end
    end

    lab1_zad2 = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "2.5"
          end
          flow margin_top: 5 do
            para "f1: ", top: 7
            f1 = edit_line width: 150, margin_left: 50
            f1.text = "50"
          end
          flow margin_top: 5 do
            para "f2: ", top: 7
            f2 = edit_line width: 150, margin_left: 50
            f2.text = "36"
          end
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "3500"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          flow { spectrum = check; para "Spectrum?" }
          button "START" do |b|
            b.click do
              func_lab1_zad2(ts, f1, f2, fs, spectrum.checked?)
            end
          end
        end
      end
    end

    lab1_zad3 = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "fi: ", top: 7
            fi = edit_line width: 150, margin_left: 50
            fi.text = "PI / 2"
          end
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "2"
          end
          flow margin_top: 5 do
            para "f: ", top: 7
            f = edit_line width: 150, margin_left: 50
            f.text = "15"
          end
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "800"
          end
          flow margin_top: 5 do
            para "ka: ", top: 7
            ka = edit_line width: 150, margin_left: 50
            ka.text = "10"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          flow { spectrum = check; para "Spectrum?" }
          button "START" do |b|
            b.click do
              func_lab1_zad3(fi, ts, f, fs, ka, spectrum.checked?)
            end
          end
        end
      end
    end

    ### LAB3 ###

    lab3 = stack hidden: true, margin_top: 10 do
      subtitle "Analog Modulation"

      flow margin_top: 10 do
        button "AM", margin_left: 15 do |b|
          b.click do
            eval("lab3_am").toggle
            eval("lab3_pm").hide
          end
        end
        button "PM", margin_left: 15 do |b|
          b.click do
            eval("lab3_am").hide
            eval("lab3_pm").toggle
          end
        end
      end
    end

    lab3_am = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "fm: ", top: 7
            fm = edit_line width: 150, margin_left: 50
            fm.text = "500"
          end
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "2"
          end
          flow margin_top: 5 do
            para "fc: ", top: 7
            fc = edit_line width: 150, margin_left: 50
            fc.text = "5"
          end
          flow margin_top: 5 do
            para "kam: ", top: 7
            kam = edit_line width: 150, margin_left: 50
            kam.text = "0.1"
          end
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "800"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          flow { spectrum = check; para "Spectrum?" }
          button "START", margin_top: 5 do |b|
            b.click do
              func_lab3_am(fm, ts, fc, kam, fs, spectrum.checked?)
            end
          end
        end
      end
    end

    lab3_pm = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "fm: ", top: 7
            fm = edit_line width: 150, margin_left: 50
            fm.text = "500"
          end
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "2"
          end
          flow margin_top: 5 do
            para "fc: ", top: 7
            fc = edit_line width: 150, margin_left: 50
            fc.text = "5"
          end
          flow margin_top: 5 do
            para "kpm: ", top: 7
            kpm = edit_line width: 150, margin_left: 50
            kpm.text = "1.1"
          end
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "800"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          flow { spectrum = check; para "Spectrum?" }
          button "START", margin_top: 5 do |b|
            b.click do
              func_lab3_pm(fm, ts, fc, kpm, fs, spectrum.checked?)
            end
          end
        end
      end
    end

    ### LAB4 ###

    lab4 = stack hidden: true, margin_top: 10 do
      subtitle "Digital Modulation"

      flow margin_top: 10 do
        button "Task1", margin_left: 15 do |b|
          b.click do
            eval("lab4_zad1").toggle
            eval("lab4_zad2").hide
          end
        end
        button "Task2", margin_left: 15 do |b|
          b.click do
            eval("lab4_zad1").hide
            eval("lab4_zad2").toggle
          end
        end
      end
    end

    lab4_zad1 = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "800"
          end
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "2"
          end
          flow margin_top: 5 do
            para "c: ", top: 7
            c = edit_line width: 150, margin_left: 50
            c.text = "1011101"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          flow { spectrum = check; para "Spectrum?" }
          flow do
            button "ASK1" do |b|
              b.click do
                func_lab4_zad1('ask1', fs, ts, c, spectrum.checked?)
              end
            end
            button "ASK2" do |b|
              b.click do
                func_lab4_zad1('ask2', fs, ts, c, spectrum.checked?)
              end
            end
            button "FSK" do |b|
              b.click do
                func_lab4_zad1('fsk', fs, ts, c, spectrum.checked?)
              end
            end
            button "PSK" do |b|
              b.click do
                func_lab4_zad1('psk', fs, ts, c, spectrum.checked?)
              end
            end
          end
        end
      end
    end

    lab4_zad2 = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "3600"
          end
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "1"
          end
          flow margin_top: 5 do
            para "text: ", top: 7
            text = edit_line width: 150, margin_left: 50
            text.text = "he has dog"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          flow { spectrum = check; para "Spectrum?" }
          flow do
            button "ASK1" do |b|
              b.click do
                func_lab4_zad2('ask1', fs, ts, text, spectrum.checked?)
              end
            end
            button "ASK2" do |b|
              b.click do
                func_lab4_zad2('ask2', fs, ts, text, spectrum.checked?)
              end
            end
            button "FSK" do |b|
              b.click do
                func_lab4_zad2('fsk', fs, ts, text, spectrum.checked?)
              end
            end
            button "PSK" do |b|
              b.click do
                func_lab4_zad2('psk', fs, ts, text, spectrum.checked?)
              end
            end
          end
        end
      end
    end


    ### LAB5 ###

    lab5 = stack hidden: true, margin_top: 10 do
      subtitle "Demodulation"

      flow margin_top: 10 do
        button "Task1", margin_left: 15 do |b|
          b.click do
            eval("lab5_zad1").toggle
          end
        end
      end
    end

    lab5_zad1 = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "fs: ", top: 7
            fs = edit_line width: 150, margin_left: 50
            fs.text = "800"
          end
          flow margin_top: 5 do
            para "ts: ", top: 7
            ts = edit_line width: 150, margin_left: 50
            ts.text = "2"
          end
          flow margin_top: 5 do
            para "c: ", top: 7
            c = edit_line width: 150, margin_left: 50
            c.text = "1011101"
          end
        end
        stack top: 50, left: 500 do
          spectrum = nil
          integral = nil
          flow { spectrum = check; para "Spectrum?"; integral = check; para "Integral?" }
          flow do
            button "ASK" do |b|
              b.click do
                func_lab5_zad1('ask', fs, ts, c, spectrum.checked?, integral.checked?)
              end
            end
            button "FSK" do |b|
              b.click do
                func_lab5_zad1('fsk', fs, ts, c, spectrum.checked?, integral.checked?)
              end
            end
            button "PSK" do |b|
              b.click do
                func_lab5_zad1('psk', fs, ts, c, spectrum.checked?, integral.checked?)
              end
            end
          end
        end
      end
    end

    ### LAB6 ###

    lab6 = stack hidden: true, margin_top: 10 do
      subtitle "Hamming Error Correction"

      flow margin_top: 10 do
        button "Task1", margin_left: 15 do |b|
          b.click do
            eval("lab6_zad1").toggle
          end
        end
      end
    end

    lab6_zad1 = stack hidden: true, margin_top: 10, margin_left: 20 do
      flow do
        stack do
          flow margin_top: 5 do
            para "bits: ", top: 7
            bits = edit_line width: 150, margin_left: 50
            bits.text = "0110"
          end
          flow margin_top: 5 do
            para "broke: ", top: 7
            broke = edit_line width: 150, margin_left: 50
            broke.text = "4"
          end
        end
        stack top: 50, left: 500 do
          button "START" do |b|
            b.click do
              func_lab6_zad1(bits, broke)
            end
          end
        end
      end
    end

  end

  def func_lab1_zad1(fi, ts, a, f, fs, spectrum)
    fi = eval_with_pi fi.text
    ts = eval_with_pi ts.text
    a = eval_with_pi a.text
    f = eval_with_pi f.text
    fs = eval_with_pi fs.text

    n = fs * ts
    data = []

    (0..n-1).each do |t|
      data << a * Math.sin(2 * Math::PI * f * t / fs + fi)
    end

    data = spectrum(n, data) if(spectrum)
    gnuplot(data, spectrum)
  end

  def func_lab1_zad2(ts, f1, f2, fs, spectrum)
    ts = eval_with_pi ts.text
    f1 = eval_with_pi f1.text
    f2 = eval_with_pi f2.text
    fs = eval_with_pi fs.text

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

    w1 = 2 * Math::PI * f1
    w2 = 2 * Math::PI * f2

    data = []

    (0..(n - 1)).each do |t|
      data << z[t] * Math.sin((w1 * t) / fs) * Math.cos((w2 * t) / fs)
    end

    data = spectrum(n, data) if(spectrum)
    gnuplot(data, spectrum)
  end

  def func_lab1_zad3(fi, ts, f, fs, ka, spectrum)
    fi = eval_with_pi fi.text
    ts = eval_with_pi ts.text
    f = eval_with_pi f.text
    fs = eval_with_pi fs.text
    ka = eval_with_pi ka.text

    n = fs * ts

    data = []

    (0..(n - 1)).each do |t|
      sum = 0.0

      (1..ka).each do |k|
        sum += (1.0 / (2.0 * k.to_f - 1.0)) * Math.sin(((2.0 * k.to_f - 1.0) * f * t.to_f) / fs.to_f)
      end

      data << (4.0 / Math::PI) * sum
    end

    data = spectrum(n, data) if(spectrum)
    gnuplot(data, spectrum)
  end

  def func_lab3_am(fm, ts, fc, kam, fs, spectrum)
    fm = eval_with_pi fm.text
    ts = eval_with_pi ts.text
    fc = eval_with_pi fc.text
    kam = eval_with_pi kam.text
    fs = eval_with_pi fs.text

    n = fs * ts
    c = []

    (0..(n - 1)).each do |t|
      c[t] = 1.0 * Math.sin((2.0 * Math::PI * fc.to_f * t.to_f) / fs.to_f)
    end

    data = []

    (0..(n - 1)).each do |t|
      data << 1.0 + (kam * c[t]) * Math.sin((2.0 * Math::PI * fm.to_f * t.to_f) / fs.to_f)
    end

    data = spectrum(n, data) if spectrum
    gnuplot(data, spectrum)
  end

  def func_lab3_pm(fm, ts, fc, kpm, fs, spectrum)
    fm = eval_with_pi fm.text
    ts = eval_with_pi ts.text
    fc = eval_with_pi fc.text
    kpm = eval_with_pi kpm.text
    fs = eval_with_pi fs.text

    n = fs * ts
    c = []

    (0..(n - 1)).each do |t|
      c[t] = 1.0 * Math.sin((2.0 * Math::PI * fc.to_f * t.to_f) / fs.to_f)
    end

    data = []

    (0..(n - 1)).each do |t|
      data << 1.0 * Math.sin(((2.0 * Math::PI * fm.to_f * t.to_f) + (kpm * c[t])) / fs.to_f)
    end

    data = spectrum(n, data) if(spectrum)
    gnuplot(data, spectrum)
  end

  def func_lab4_zad1(subtask, fs, ts, c, spectrum)
    fs = eval_with_pi fs.text
    ts = eval_with_pi ts.text
    c = eval_with_pi c.text

    c = c.to_s.split("").map(&:to_i)

    n = (fs * ts).to_f
    w = c.size.to_f
    tb = (n / w).to_i

    data = []

    c.each_with_index do |bit, index|
      case subtask
      when 'ask1'
        f = n * (1.0 / tb)
        fi = 0.0
        if bit == 1
          a = 2.0
        else
          a = 0.0
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end

      when 'ask2'
        f = n * (1.0 / tb)
        fi = 0.0
        if bit == 1
          a = 2.0
        else
          a = 1.0
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end

      when 'fsk'
        a = 1.0
        fi = 0.0
        if bit == 1
          f = (n + 1.0) / tb
        else
          f = (n + 2.0) / tb
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end

      when 'psk'
        a = 1.0
        f = n * (1.0 / tb)
        if bit == 1
          fi = 0.0
        else
          fi = Math::PI
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end
      end
    end

    data = spectrum(data.size, data) if spectrum
    gnuplot(data, spectrum)
  end

  def func_lab4_zad2(subtask, fs, ts, text, spectrum)
    fs = eval_with_pi fs.text
    ts = eval_with_pi ts.text
    text = text.text

    c = text.to_s.unpack('c*').map {|e| e.to_s(2).split('').map(&:to_i) }.flatten

    n = (fs * ts).to_f
    w = c.size.to_f
    tb = (n / w).to_i

    data = []

    c.each_with_index do |bit, index|
      case subtask
      when 'ask1'
        f = n * (1.0 / tb)
        fi = 0.0
        if bit == 1
          a = 2.0
        else
          a = 0.0
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end

      when 'ask2'
        f = n * (1.0 / tb)
        fi = 0.0
        if bit == 1
          a = 2.0
        else
          a = 1.0
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end

      when 'fsk'
        a = 1.0
        fi = 0.0
        if bit == 1
          f = (n + 1.0) / tb
        else
          f = (n + 2.0) / tb
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end

      when 'psk'
        a = 1.0
        f = n * (1.0 / tb)
        if bit == 1
          fi = 0.0
        else
          fi = Math::PI
        end

        ((tb * index)...(tb * (index + 1))).each do |t|
          data << a.to_f * Math.sin(((2.0 * Math::PI * f.to_f * t.to_f / fs.to_f) + fi))
        end
      end
    end

    data = spectrum(data.size, data) if spectrum
    gnuplot(data, spectrum)
  end

  def func_lab5_zad1(subtask, fs, ts, c, spectrum, integral)
    fs = eval_with_pi fs.text
    ts = eval_with_pi ts.text
    c = eval_with_pi c.text

    c = c.to_s.split("").map(&:to_i)

    n = (fs * ts).to_f
    w = c.size.to_f
    tb = (n / w).to_i

    data = []
    ask = []
    psk = []
    fsk1 = []
    fsk2 = []
    fsk = []

    ask_dt = []
    fsk1_dt = []
    fsk2_dt = []
    psk_dt = []

    c.each_with_index do |bit, index|
      case subtask
      when 'ask'
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

          if integral
            ask << ask_dt.inject(:+)
          else
            if ask_dt.inject(:+) > 0.1
              ask << 1
            else
              ask << 0
            end
          end
        end

        data = ask

      when 'fsk'
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
          if integral
            fsk << fsk1[j] - fsk2[j]
          else
            if fsk1[j] - fsk2[j] > 0.1
              fsk << 1
            else
              fsk << 0
            end
          end
        end

        data = fsk

      when 'psk'
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

          if integral
            psk << psk_dt.inject(:+)
          else
            if psk_dt.inject(:+) > 0.1
              psk << 1
            else
              psk << 0
            end
          end
        end

        data = psk
      end
    end

    data = spectrum(data.size, data) if spectrum
    gnuplot(data, spectrum)
  end

  def func_lab6_zad1(bits, broke)
    bits = bits.text
    broke = broke.text

    bits = bits.to_s.scan(/\w/).map(&:to_i).reverse

    broke = broke.to_i
    broke = broke - 1

    output = []
    output[2] = bits[0]
    output[4] = bits[1]
    output[5] = bits[2]
    output[6] = bits[3]
    output[0] = output[2] ^ output[4] ^ output[6]
    output[1] = output[2] ^ output[5] ^ output[6]
    output[3] = output[4] ^ output[5] ^ output[6]

    input = []
    output.each do |el|
      input << el
    end
    input[broke] = (input[broke] - 1).abs

    save_input = []
    input.each do |el|
      save_input << el
    end

    x = []
    x[0] = input[2] ^ input[4] ^ input[6]
    x[1] = input[2] ^ input[5] ^ input[6]
    x[2] = input[4] ^ input[5] ^ input[6]

    errors = []
    errors[0] = (input[0] ^ x[0]) * 2**0
    errors[1] = (input[1] ^ x[1]) * 2**1
    errors[2] = (input[3] ^ x[2]) * 2**2

    error_index = errors.inject(:+)
    error_index = error_index - 1

    if error_index > 0
      input[error_index] = (input[error_index] - 1).abs
    end

    to_print = []
    to_print << input[6]
    to_print << input[5]
    to_print << input[4]
    to_print << input[2]

    alert "Message: #{bits.join('')}\nHamming Code: #{output.join('')}\nReceived: #{save_input.join('')}\nFixed: #{to_print.join('')}"
  end

  ### HELPERS ###

  def eval_with_pi(string)
    string.gsub! "PI", "Math::PI"
    eval(string)
  end

  def gnuplot(data, spectrum = false)
    data_size = data.size

    if spectrum
      data_size = data_size / 2
    end

    commands = %Q(
      set offset graph 0.1, graph 0.1, graph 0.1, graph 0.1
      set xrange [0:#{data_size}]
      plot "-" with lines notitle
    )

    data.each_with_index do |y, x|
      commands << x.to_s + " " + y.to_s + "\n"
    end
    commands << "e\n"

    IO.popen("gnuplot -p", "w") { |io| io.puts commands }
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
end
