require 'find'
require 'digest'

def count_files_with_same_content(directory)
  content_count = Hash.new(0)

  Find.find(directory) do |path|
    next unless File.file?(path)
    
    current_count = 0
    current_content = ''
    
    File.open(path, 'rb') do |file|
      digest = Digest::SHA256.new
      while chunk = file.read(1024 * 1024) # Read 1MB chunks
        digest.update(chunk)
        current_content << chunk
      end
      hash = digest.hexdigest
      content_count[hash] += 1
    end
  end

  max_count = 0
  max_content = nil

  content_count.each do |content, count|
    if count > max_count
      max_count = count
      max_content = content
    end
  end

  [max_content, max_count]
end

directory_path = ARGV[0]
content, count = count_files_with_same_content(directory_path)
puts "#{content} #{count}"
