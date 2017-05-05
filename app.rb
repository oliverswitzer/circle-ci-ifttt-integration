Bundler.require :web
Bundler.require :development if development?

Dotenv.load

post '/webhooks/circleci/receive' do
  request.body.rewind

  circlePayload = JSON.parse request.body.read
  buildStatus = circlePayload['payload']['status']

  if buildStatus == 'success'
    HTTParty.post("https://maker.ifttt.com/trigger/build_passing/with/key/#{ENV['IFTTT_KEY']}")
  elsif buildStatus == 'failed'
    HTTParty.post("https://maker.ifttt.com/trigger/build_failing/with/key/#{ENV['IFTTT_KEY']}")
  end

  200
end