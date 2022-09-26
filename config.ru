require "./config/environment"



$app ||= Sinatra::Application

run $app