# frozen_string_literal

require_relative "../merge_request"

module GitChlog
  module GitRepoActions
    class LoadMergedRequests
      attr_reader :release, :code_hosting

      def initialize(release:, code_hosting:)
        @release = release
        @code_hosting = code_hosting
      end

      def call
        raw_git_merge_commits
          .select { |raw_commit| is_merge_request?(raw_commit) }
          .map { |raw_commit| build_merge_request(raw_commit) }
      end

      private

        def raw_git_merge_commits
          `git log --merges --pretty="%aI|%s|%b" #{tag_range}`
            .split("\n")
            .map { |line| Hash[[:date, :subject, :body].zip(line.split("|"))] }
            .select { |m| !m[:subject].nil? }
        end

        def tag_range
          [release.git_ref, release.prev_tag].compact.join("...")
        end

        def is_merge_request?(raw_commit)
          code_hosting.is_merge_request?(raw_commit)
        end

        def build_merge_request(raw_commit)
          MergeRequest.new(
            code_hosting.extract_merge_request_params(raw_commit)
          )
        end
    end
  end
end
