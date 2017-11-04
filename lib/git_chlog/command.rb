# frozen_string_literal: true

require_relative "command_actions/print_changelog"
require_relative "code_hosting"
require_relative "git_repo"
require_relative "issue_tracker"

require 'optparse'

module GitChlog
  class Command
    attr_reader :argv

    def initialize(argv:)
      @argv = argv
    end

    def call
      print_changelog_action(parse_options).call
    end

    private

      def print_changelog_action(options)
        git_repo = GitRepo.new(options)

        CommandActions::PrintChangeLog.new(
          code_hosting: CodeHosting.build(git_repo.origin_remote_url),
          git_repo: git_repo,
          issue_tracker: IssueTracker::PivotalTracker
        )
      end

      def parse_options
        options = {
          prepare_release: false
        }

        OptionParser.new do |opts|
          opts.banner = "Usage: git chlog [options]"

          opts.on(
            "--prepare-release=[TAG]",
            "Add unreleased changes when preparing new release") do |tag|
            options[:prepare_release] = tag || "HEAD"
          end

          opts.on("-h", "--help", "Prints this help") do
            puts opts
            exit
          end
        end.parse!(argv)

        options
      end
  end
end
