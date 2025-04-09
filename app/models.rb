# frozen_string_literal: true

# get the path of the root of the app
APP_ROOT = File.expand_path('..', __dir__)
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).sort.each { |file| require file }
