require 'octokit'
require 'active_support/time'
require 'net/http'

class Judge
  def initialize(repo)
    @repo = repo
    @github = Octokit::Client.new(login: ENV['GITHUB_LOGIN'], oauth_token: ENV['GITHUB_TOKEN'])
  end

  def score
    [
      code_climate_score,
      issue_score,
      travis_ci_score,
      pull_request_score,
      stargazer_score,
      commit_score
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

  def travis_ci_score
    code = Net::HTTP.get_response(URI("https://api.travis-ci.org/#{@repo}.png")).code
    if code == '200'
      5
    else
      0
    end
  end

  def issue_score
    if @github.list_issues(@repo).count < 30
      10
    else
      0
    end
  end

  def pull_request_score
    if @github.pull_requests(@repo).count < 5
      20
    else
      0
    end
  end

  def stargazer_score
    if @github.stargazers(@repo, page: 4).count >= 10
      50
    else
      0
    end
  end

  def commit_score
    if @github.commits_since(@repo, 1.week.ago.to_s).count > 0
      10
    else
      0
    end
  end
end
