require 'pdf-reader'

class InvalidFileFormatError < StandardError; end

module ResidentList
  class PDF
    SKIP_WORDS = ['information', 'page', 'Unknown', 'disciple', 'Neighborhood', 'Powered', 'credit card'].freeze
    def initialize(file)
      raise ArgumentError, 'A file must be provided' if file.nil?
      @file = file
    end

    def load_residents
      # Guard clause to check if @file is a PDF
      raise InvalidFileFormatError, 'The provided file is not a PDF.' unless @file.respond_to?(:path) && File.extname(@file.path) == '.pdf'

      reader = ::PDF::Reader.new(@file.path)

      # Guard clause to check if the file contains the string "blesseveryhome"
      found = reader.pages.detect do |page|
        page.text.each_line.detect { |line| line.include?("blesseveryhome") }
      end
      raise InvalidFileFormatError, 'The provided file is incorrectly formatted.' unless found

      # Use a set to store the residents to avoid duplicates
      residents = Set.new

      reader.pages.each do |page|
        page.text.each_line do |line|
          # Remove blank lines or lines containing skip words
          next if line.strip.empty? || SKIP_WORDS.any? { |word| line.include?(word) }
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
