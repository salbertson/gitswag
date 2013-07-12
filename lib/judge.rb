require 'octokit'
require 'net/http'
require 'active_support/time'

class Judge
  def initialize(repo)
    @repo = repo
    @github = Octokit::Client.new(login: ENV['GITHUB_LOGIN'], oauth_token: ENV['GITHUB_TOKEN'])
  end

  def score
    [
      code_climate_score,
      coveralls_score,
      issue_score,
      travis_ci_score,
      commit_score,
      pull_request_score,
      stargazer_score
    ].inject(0) { |total, score| total + score }
  end

  private

  def code_climate_score
    code = Net::HTTP.get_response(URI("https://codeclimate.com/github/#{@repo}.png")).code
    if code == '200'
      5
    else
      0
    end
  end

  def coveralls_score
    code = Net::HTTP.get_response(URI("https://coveralls.io/r/#{@repo}")).code
    if code == '200'
      5
    else
      0
    end
  end

  def travis_ci_score
    code = Net::HTTP.get_response(URI("https://api.travis-ci.org/#{@repo}.png")).code
    if code == '200'
      5
    else
      0
    end
  end

  def commit_score
    if @github.commits_since(@repo, 1.week.ago.to_s).count > 0
      10
    elsif @github.commits_since(@repo, 1.month.ago.to_s).count > 0
      3
    else
      0
    end
  end

  def issue_score
    if @github.list_issues(@repo).count < 15
      10
    elsif @github.list_issues(@repo).count < 25
      8
    elsif @github.list_issues(@repo, page: 2).count < 15
      6
    elsif @github.list_issues(@repo, page: 2).count < 30
      4
    elsif @github.list_issues(@repo, page: 3).count < 15
      2
    else
      0
    end
  end

  def pull_request_score
    if @github.pull_requests(@repo).count < 5
      20
    elsif @github.pull_requests(@repo).count < 10
      10
    elsif @github.pull_requests(@repo).count < 15
      5
    else
      0
    end
  end

  def stargazer_score
    if @github.stargazers(@repo, page: 34).count >= 10
      50
    elsif @github.stargazers(@repo, page: 20).count >= 1
      40
    elsif @github.stargazers(@repo, page: 10).count >= 1
      35
    elsif @github.stargazers(@repo, page: 4).count >= 10
      25
    elsif @github.stargazers(@repo, page: 2).count >= 1
      10
    else
      0
    end
  end
end
