# frozen_string_literal: true

require "time"

module GitChlog
  class Release
    attr_reader :tag, :git_ref, :label, :date
    attr_accessor :prev_tag

    def self.build_head(tag:, label:)
      Release.new(tag: tag, date: Time.now, git_ref: "HEAD", label: label)
    end

    def initialize(tag:, date:, git_ref: nil, label: nil)
      @tag = tag
      @git_ref = git_ref || tag
      @label = label || tag
      @date = Time.parse(date.to_s)
    end

    def version_number
      tag.sub("v", "")
    end

    def <=>(other)
      date <=> other.date
    end
  end
end
