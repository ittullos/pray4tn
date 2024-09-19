# frozen_string_literal: true

require 'pdf-reader'

class User < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  has_many :residents, -> { order(position: :asc) }

  def load_residents(file)
    reader = PDF::Reader.new(file[:tempfile].path)
    save_next_line = false

    reader.pages.each do |page|
      page.text.each_line do |line|
        # Remove blank lines
        next if line.strip.empty?

        if save_next_line
          if !line.include?('information') && !line.include?('page') && !line.include?('Unknown')
            puts "Saving line: #{line.strip}"
            residents.create(name: line.strip).save
          end
          save_next_line = false
          next
        end

        if line.include?('pray') && line.include?('care') && line.include?('share') && line.include?('disciple')
          save_next_line = true
        end

        if line.include?('Neighborhood')
          save_next_line = true
        end
      end
    end
  end

end
