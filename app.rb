require 'sinatra'
require 'octokit'
require './lib/judge'

get '/:owner/:repo.png' do
  # stars 5x
  # open pull requests 2x
  # open issues 1x
  # commits in last month 1x
  # code climate 0.5x
  # travis ci setup 0.5x

  judge = Judge.new
  repo = "#{params[:owner]}/#{params[:repo]}"

  if judge.score(repo) >= 5
    send_file 'green.png'
  else
    send_file 'red.png'
  end
end
