def compare_hashes(hash1, hash2)
  # Find the maximum width of each column
  key_width = (hash1.keys + hash2.keys).map(&:length).max
  value_width = (hash1.values + hash2.values).map { |v| v.to_s.length }.max

  # Print the table header
  puts "+#{'-' * (key_width + 2)}+#{'-' * (value_width + 2)}+#{'-' * (value_width + 2)}+"
  puts "| #{'Key'.ljust(key_width)} | #{'You'.ljust(value_width)} | #{'Rand'.ljust(value_width)} |"
  puts "+#{'-' * (key_width + 2)}+#{'-' * (value_width + 2)}+#{'-' * (value_width + 2)}+"

  # Print the table rows
  hash1.each do |key, value|
    puts "| #{key.to_s.ljust(key_width)} | #{value.to_s.ljust(value_width)} | #{hash2[key].to_s.ljust(value_width)} |"
  end

  # Print the table footer
  puts "+#{'-' * (key_width + 2)}+#{'-' * (value_width + 2)}+#{'-' * (value_width + 2)}+"
end

def print_one_hash hash
  key_width = hash.length
  value_width = hash.values.map { |v| v.to_s.length }.max

  # Print the table header
  puts "+#{'-' * (key_width + 2)}+#{'-' * (value_width + 2)}+#{'-' * (value_width + 2)}+"
  puts "| #{'Key'.ljust(key_width)} | #{'You'.ljust(value_width)} | #{'Rand'.ljust(value_width)} |"
  puts "+#{'-' * (key_width + 2)}+#{'-' * (value_width + 2)}+#{'-' * (value_width + 2)}+"

  # Print the table rows
  hash.each do |key, value|
    puts "| #{key.to_s.ljust(key_width)} | #{value.to_s.ljust(value_width)} | #{'nil'.to_s.ljust(value_width)} |"
  end

  # Print the table footer
  puts "+#{'-' * (key_width + 2)}+#{'-' * (value_width + 2)}+#{'-' * (value_width + 2)}+"
end
