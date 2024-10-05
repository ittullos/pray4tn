require 'pdf-reader'

class InvalidFileFormatError < StandardError; end

module ResidentList
  class PDF
    def initialize(file)
      @file = file
    end

    def load_residents
      # Guard clause to check if @file is a PDF
      raise InvalidFileFormatError, 'The provided file is not a PDF.' unless @file && File.extname(@file) == '.pdf'

      reader = ::PDF::Reader.new(@file.path)

      # Guard clause to check if the file contains the string "blesseveryhome"
      file_content = reader.pages.map(&:text).join(" ")
      raise InvalidFileFormatError, 'The provided file is incorrectly formatted.' unless file_content.include?  ("blesseveryhome")

      skip_words = ['information', 'page', 'Unknown','disciple', 'Neighborhood', 'Powered', 'credit card']
      # Use a set to store the residents to avoid duplicates
      residents = Set.new

      reader.pages.each do |page|
        page.text.each_line do |line|
          # Remove blank lines or lines containing skip words
          next if line.strip.empty? || skip_words.any? { |word| line.include?(word) }
          # Check if the line contains any number
          next if line.match?(/\d/)
          # Add the valid line to the residents set
          residents << line.strip
        end
      end
      residents
    end
  end
end
