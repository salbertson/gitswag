require 'active_support/time'

class Judge
  def initialize
    @github = Octokit::Client.new
  end

  def score(repo)
    score = 0

    if @github.stargazers(repo, page: 4).count >= 10
      score += 50 
    end

    if @github.commits_since(repo, 1.week.ago.to_s).count > 0
      score += 10
    end

    score
  end
end
