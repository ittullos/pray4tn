require 'spec_helper'
require_relative '../../app/services/resident_list'
require './app/models/user'

include AuthenticationSpecHelpers

RSpec.describe ResidentList::PDF do
  let(:pdf_file) { Rack::Test::UploadedFile.new('spec/fixtures/sample.pdf', 'application/pdf') }
  let(:bad_pdf) { Rack::Test::UploadedFile.new('spec/fixtures/bad_sample.pdf', 'application/pdf')}
  let(:duplicate_name_sample) { Rack::Test::UploadedFile.new('spec/fixtures/duplicate_name_sample.pdf', 'application/pdf')}

  context 'when the PDF file is valid' do
    it 'processes the uploaded PDF file' do
      expect(ResidentList::PDF.new(pdf_file).load_residents.count).to eq(23)
    end

    it 'filters out unnecessary lines' do
      skip_words = ['information', 'page', 'Unknown','disciple', 'Neighborhood', 'Powered', 'credit card']

      residents = ResidentList::PDF.new(pdf_file).load_residents
      expect(residents).not_to include(*skip_words)
    end

    it 'skips over duplicate names' do
      residents = ResidentList::PDF.new(duplicate_name_sample).load_residents
      expect(residents.count).to eq(3)
    end

  end

  context 'when the file is not a pdf' do
    it 'raises an error' do
      expect { ResidentList::PDF.new("cat.gif").load_residents }.to raise_error(StandardError, "The provided file is not a PDF.")
    end
  end

  context 'when the pdf is incorrectly formatted' do
    it "raises an error" do
      expect { ResidentList::PDF.new(bad_pdf).load_residents }.to raise_error(StandardError, "The provided file is incorrectly formatted.")
    end
  end
end
