print "Bits to transfer (max 4) (eg. 0110): "
bits = gets
bits = bits.scan(/\w/).map(&:to_i).reverse

print "Select bit to broke (1-7): "
broke = gets
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

output[broke] = (output[broke] - 1).abs

input = output

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

print "Received: "
print to_print.join('')
print "\n"
