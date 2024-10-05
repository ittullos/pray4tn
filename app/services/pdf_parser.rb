require 'pdf-reader'

class PdfParser
  def initialize(file, user)
    @file = file
    @user = user
  end

  def load_residents
    reader = PDF::Reader.new(@file[:tempfile].path)
    skip_words = ['information', 'page', 'Unknown','disciple', 'Neighborhood', 'Powered', 'credit card']

    reader.pages.each do |page|
      page.text.each_line do |line|
        # Remove blank lines or lines containing skip words
        next if line.strip.empty? || skip_words.any? { |word| line.include?(word) }
        # Check if the line contains any number
        next if line.match?(/\d/)

        puts "Processing line: #{line.strip}"
        @user.residents.create(name: line.strip).save
      end
    end
  end
end
