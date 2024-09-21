require 'spec_helper'
require_relative '../../app/services/pdf_parser'
require './app/models/user'

include AuthenticationSpecHelpers

RSpec.describe PdfParser do
  context 'when the PDF file is valid' do
    let(:pdf_file) { Rack::Test::UploadedFile.new('spec/fixtures/sample.pdf', 'application/pdf') }
    let!(:user) { authenticated }

    it 'processes the uploaded PDF file' do
      resident_count = Resident.count
      PdfParser.new({tempfile: pdf_file}, user).load_residents

      expect(Resident.count).to eq(resident_count + 23)
    end
  end
end
