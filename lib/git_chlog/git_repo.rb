# frozen_string_literal: true

require_relative "git_repo_actions/load_releases"
require_relative "git_repo_actions/load_merged_requests"

module GitChlog
  class GitRepo
    attr_reader :options

    def initialize(options = {})
      @options = options.dup
    end

    def origin_remote_url
      `git remote get-url origin`.strip
    end

    def first_commit_sha
      `git rev-list --max-parents=0 HEAD`.strip[0...9]
    end

    def prev_tag(current_tag)
      `git log --format="%D" #{current_tag}~1`
        .split("\n")
        .select { |line| line.start_with?("tag:") }
        .first
        &.match(/tag: ([^,]+)/)&.captures&.first
    end

    def load_releases
      GitRepoActions::LoadReleases.new(
        git_repo: self,
        head_release_tag: options[:prepare_release]
      ).call
    end

    def load_merged_requests(release, code_hosting)
      GitRepoActions::LoadMergedRequests.new(
        release: release, code_hosting: code_hosting
      ).call
    end
  end
end
