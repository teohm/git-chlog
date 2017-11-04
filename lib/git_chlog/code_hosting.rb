# frozen_string_literal: true

module GitChlog
  module CodeHosting
    def self.build(repo_url)
      if GitHub.matching_repo_url?(repo_url)
        GitHub.new(repo_url)
      else
        raise "unsupported repo url: #{repo_url}"
      end
    end

    class GitHub
      attr_reader :repo_name

      def self.matching_repo_url?(repo_url)
        !(/github\.com/.match(repo_url).nil?)
      end

      def initialize(github_repo_url)
        @repo_name = extract_repo_name(github_repo_url)
      end

      def extract_merge_request_params(raw_commit)
        {
          id: extract_pull_id(raw_commit[:subject]),
          title: raw_commit[:body],
          date: raw_commit[:date]
        }
      end

      def is_merge_request?(raw_commit)
        raw_commit[:subject].start_with?("Merge pull request")
      end

      def base_url
        "https://github.com"
      end

      def merge_request_url(id)
        [base_url, repo_name, "pull", id].join("/")
      end

      def diff_url(from:, to:)
        [base_url, repo_name, "compare", "#{from}...#{to}"].join("/")
      end

      def tag_url(tag)
        [base_url, repo_name, "tree", tag].join("/")
      end

      private

        def extract_repo_name(repo_url)
          /git@github.com:([^.]+).git/.match(repo_url)&.captures&.first
        end

        def extract_pull_id(commit_subject)
          /#(\d+)/.match(commit_subject).captures.first
        end
    end
  end
end
