require 'sinatra'
require './lib/judge'

class App < Sinatra::Application
  get '/:owner/:repo.png' do
    repo = "#{params[:owner]}/#{params[:repo]}"
    judge = Judge.new(repo)
    score = judge.score

    if score >= 50
      send_file 'green.png'
    else
      send_file 'red.png'
    end
  end
end
