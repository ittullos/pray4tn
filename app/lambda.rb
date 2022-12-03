require 'json'
require 'rack'
require 'base64'
require 'app'
require "sinatra/cors"
require "sequel"

# Global object that responds to the call method. Stay outside of the handler
# to take advantage of container reuse
$app ||= Sinatra::Application

set :allow_origin, "*"
set :allow_methods, "GET,POST,DELETE,PATCH,OPTIONS"
set :allow_headers, "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, if-modified-since"
set :expose_headers, "location,link"

def handler(event:, context:)

  puts "Lambda: top of handler"

  # Check if the body is base64 encoded. If it is, try to decode it
  body = if event['isBase64Encoded']
    Base64.decode64 event['body']
  else
    event['body']
  end || ''

  # Rack expects the querystring in plain text, not a hash
  headers = event.fetch 'headers', {}

  puts "Lambda: HEADERS: #{headers}"
  puts "Lambda: EVENT: #{event}"

  env = {
    'REQUEST_METHOD' => event.fetch('httpMethod'),
    'SCRIPT_NAME' => '',
    'PATH_INFO' => event.fetch('path', ''),
    'QUERY_STRING' => Rack::Utils.build_query(event['queryStringParameters'] || {}),
    'SERVER_NAME' => headers.fetch('Host', 'localhost'),
    'SERVER_PORT' => headers.fetch('X-Forwarded-Port', 443).to_s,

    'rack.version' => Rack::VERSION,
    'rack.url_scheme' => headers.fetch('CloudFront-Forwarded-Proto') { headers.fetch('X-Forwarded-Proto', 'https') },
    'rack.input' => StringIO.new(body),
    'rack.errors' => $stderr,
    # 'db_host' => kms_decrypt(ENV["DB1"]),
    # 'db_pwrd' => kms_decrypt(ENV["DB2"]),
  }

  puts "Lambda: env: #{env}"

  # Pass request headers to Rack if they are available
  headers.each_pair do |key, value|
    # 'CloudFront-Forwarded-Proto' => 'CLOUDFRONT_FORWARDED_PROTO'
    # Content-Type and Content-Length are handled specially per the Rack SPEC linked above.
    name = key.upcase.gsub '-', '_'
    header = case name
      when 'CONTENT_TYPE', 'CONTENT_LENGTH'
        name
      else
        "HTTP_#{name}"
    end
    env[header] = value.to_s
  end

  begin
    puts "Lambda: calling app"
    # Response from Rack must have status, headers and body
    status, headers, body = $app.call env

    # body is an array. We combine all the items to a single string
    body_content = ""
    body.each do |item|
      body_content += item.to_s
    end

    # We return the structure required by AWS API Gateway since we integrate with it
    # https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    response = {
      'statusCode' => status,
      'headers' => headers,
      'body' => body_content
    }
    if event['requestContext'].has_key?('elb')
      # Required if we use Application Load Balancer instead of API Gateway
      response['isBase64Encoded'] = false
    end
  rescue Exception => exception
    # If there is _any_ exception, we return a 500 error with an error message
    response = {
      'statusCode' => 500,
      'body' => exception.message
    }
  end

  # By default, the response serializer will call #to_json for us
  response
end
