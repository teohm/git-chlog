# frozen_string_literal: true

require_relative "../release"

module GitChlog
  module GitRepoActions
    class LoadReleases
      attr_reader :git_repo, :head_release_tag

      def initialize(git_repo:, head_release_tag:)
        @git_repo = git_repo
        @head_release_tag = head_release_tag
      end

      def call
        raw_git_tag_data
          .map { |release_params| Release.new(release_params) }
          .sort
          .reverse
          .unshift(head_release)
          .compact
          .map { |release|
            release.prev_tag = git_repo.prev_tag(release.git_ref)
            release
          }
      end

      private

        def head_release
          if head_release_tag
            Release.build_head(tag: head_release_tag, label: head_release_tag)
          else
            nil
          end
        end

        def raw_git_tag_data
          `git tag --format='%(refname:short)|%(creatordate:iso8601)'`
            .split("\n")
            .map { |line| Hash[[:tag, :date].zip(line.split("|"))] }
        end
    end
  end
end
