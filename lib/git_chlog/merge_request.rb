# frozen_string_literal: true

require "time"

class GitChlog::MergeRequest
  attr_reader :id, :title, :date

  def initialize(id:, title:, date:)
    @id = id
    @title = title
    @date = Time.parse(date)
  end
end
