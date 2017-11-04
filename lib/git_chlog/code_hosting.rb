# frozen_string_literal: true

module GitChlog
  class CodeHosting
    CONFIG = {
      github: {
        repo_url_patterns: [
          %r{github\.com}
        ],
        extract_repo_name_patterns: [
          %r{git@github\.com:([^.]+)\.git},
          %r{https://github\.com/([^.]+)\.git}
        ],
        extract_merge_request_id_patterns: [
          %r{#(\d+)}
        ],
        merge_request_subject_prefix: "Merge pull request",
        merge_request_url: "https://github.com/%{repo_name}/pull/%{id}",
        diff_url: "https://github.com/%{repo_name}/compare/%{from}...%{to}",
        tag_url: "https://github.com/%{repo_name}/tree/%{tag}"
      }
    }

    # Generated format:
    # ```
    # [
    #   [pattern1, hosting1],
    #   [pattern2, hosting1],
    #   ...
    # ]
    # ```
    REPO_URL_PATTERN_MAPPINGS = CONFIG
      .map { |k,v| [k, v[:repo_url_patterns]] }
      .flat_map {|n| n[1].product [n[0]] }

    def self.build(repo_url)
      if hosting = guess_code_hosting(repo_url)
        CodeHosting.new(repo_url, CONFIG.fetch(hosting))
      else
        raise "unsupported code hosting: #{repo_url}"
      end
    end

    def self.guess_code_hosting(repo_url)
      REPO_URL_PATTERN_MAPPINGS.each do |pattern, hosting|
        return hosting if pattern.match(repo_url)
      end
    end

    attr_reader :repo_name, :config

    def self.matching_repo_url?(repo_url)
      !(/github\.com/.match(repo_url).nil?)
    end

    def initialize(github_repo_url, config)
      @config = config
      @repo_name = extract_repo_name(github_repo_url)
    end

    def extract_merge_request_params(raw_commit)
      {
        id: extract_merge_request_id(raw_commit[:subject]),
        title: raw_commit[:body],
        date: raw_commit[:date]
      }
    end

    def is_merge_request?(raw_commit)
      raw_commit[:subject].start_with?(config[:merge_request_subject_prefix])
    end

    def merge_request_url(id)
      sprintf(config[:merge_request_url], repo_name: repo_name, id: id)
    end

    def diff_url(from:, to:)
      sprintf(config[:diff_url], repo_name: repo_name, from: from, to: to)
    end

    def tag_url(tag)
      sprintf(config[:tag_url], repo_name: repo_name, tag: tag)
    end

    private

      def extract_repo_name(repo_url)
        config[:extract_repo_name_patterns].each do |pattern|
          if found = pattern.match(repo_url)&.captures&.first
            return found
          end
        end
      end

      def extract_merge_request_id(commit_subject)
        config[:extract_merge_request_id_patterns].each do |pattern|
          if found = pattern.match(commit_subject)&.captures&.first
            return found
          end
        end
      end
  end
end
