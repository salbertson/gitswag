require 'sinatra'
require 'open-uri'
require './lib/judge'

class App < Sinatra::Application
  get '/:owner/:repo.png' do
    repo = "#{params[:owner]}/#{params[:repo]}"
    judge = Judge.new(repo)
    score = judge.score

    content_type 'image/png'
    open("http://placehold.it/#{score * 2}x#{score * 2}").read
  end
end
