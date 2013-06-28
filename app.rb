require 'sinatra'
require 'octokit'
require 'active_support/time'

get '/:owner/:repo.png' do
  client = Octokit::Client.new
  commits = client.commits_since("#{params[:owner]}/#{params[:repo]}", 1.week.ago.to_s)

  if commits.count > 0
    send_file 'green.png'
  else
    send_file 'red.png'
  end
end
