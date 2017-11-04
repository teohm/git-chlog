# frozen_string_literal: true

module GitChlog
  module CommandActions
    class PrintChangeLog
      attr_reader :code_hosting, :git_repo, :issue_tracker, :config

      DEFAULT_CONFIG = {
        title: "# Change Log",
        diff_url_label: "Full Changelog"
      }.freeze

      def initialize(code_hosting:, git_repo:, issue_tracker:, config: {})
        @code_hosting = code_hosting
        @git_repo = git_repo
        @issue_tracker = issue_tracker
        @config = DEFAULT_CONFIG.merge(config)
      end

      def call
        with_output do |out|
          out.puts config[:title]

          until releases.empty? do
            release = releases.shift

            print_release_heading(out, release)
            out.puts

            print_full_changelog_link(out, release)

            merged_requests(release).each do |merge_request|
              print_merged_request(out, merge_request)
            end
            out.puts
          end
        end
      end

      private

        def print_release_heading(out, release)
          out.puts("## [#{release.label}](#{code_hosting.tag_url(release.tag)})")
        end

        def print_full_changelog_link(out, release)
          prev_tag = release.prev_tag || git_repo.first_commit_sha
          out.puts(
            "[#{config[:diff_url_label]}]"\
            "(#{code_hosting.diff_url(from: prev_tag, to: release.tag)})"
          )
        end

        def print_merged_request(out, merge_request)
          out.puts(
            "* " \
            " #{format_date(merge_request.date)}" \
            " - #{link_to_issue_tracker(merge_request.title)} " \
            " [##{merge_request.id}]"\
            "(#{code_hosting.merge_request_url(merge_request.id)})"
          )
        end

        def format_date(date)
          date.strftime("%F")
        end

        def link_to_issue_tracker(title)
          issue_tracker.decorate_issue(title)
        end

        def releases
          @_releases ||= git_repo.load_releases
        end

        def merged_requests(release)
          git_repo.load_merged_requests(release, code_hosting)
        end

        def with_output
          yield(STDOUT.to_io)
        end
    end
  end
end
