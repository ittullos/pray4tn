require 'spec_helper'
require_relative '../../app/services/pdf_parser'
require './app/models/user'

include AuthenticationSpecHelpers

RSpec.describe PdfParser do
  let(:pdf_file) { Rack::Test::UploadedFile.new('spec/fixtures/sample.pdf', 'application/pdf') }
  let!(:user) { authenticated }
  let(:pdf_parser) { double(PdfParser) }

  context 'when the PDF file is valid' do
    it 'processes the uploaded PDF file' do
      allow(pdf_parser).to receive(:load_residents).and_return(['foobar', 'Tommy Jones', 'information', 'Elon Musk', 'etc.'])

      expect { pdf_parser.load_residents }.to change(Resident, :count).by(2)
    end

    it 'filters out unnecessary lines'

    it 'creates the users residents'

    it 'skips over duplicate names'

  end

  context 'when the PDF file is not valid' do
    it 'raises an error' do
      allow(pdf_parser).to receive(:parse_pdf).and_raise(StandardError.new("Invalid PDF"))

      expect { pdf_parser.parse_pdf }.to raise_error(StandardError, "Invalid PDF")
    end
  end
end
