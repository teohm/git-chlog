# frozen_string_literal: true

class GitChlog::IssueTracker
  class PivotalTracker
    def self.decorate_issue(text)
      text.gsub(/#(\d+)/,
        "[#\\1](https://www.pivotaltracker.com/story/show/\\1)")
    end
  end
end
