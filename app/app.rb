require 'open-uri'
require './lib/judge'

class App < Sinatra::Application
  get '/' do
  end

  get '/github/:owner/:repo.png' do
    repo = "#{params[:owner]}/#{params[:repo]}"
    score = $redis.get(repo)

    if score.nil?
      judge = Judge.new(repo)
      score = judge.score
      $redis.set(repo, score)
    else
      score = score.to_i
    end

    content_type 'image/png'
    open("http://placehold.it/#{score * 2}x#{score * 2}").read
  end
end
