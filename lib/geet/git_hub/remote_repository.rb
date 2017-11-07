# frozen_string_literal: true

require_relative 'abstract_issue'
require_relative 'api_helper'
require_relative 'gist'
require_relative 'issue'
require_relative 'milestone'
require_relative 'pr'

module Geet
  module GitHub
    class RemoteRepository
      def initialize(local_repository, api_helper)
        @local_repository = local_repository
        @api_helper = api_helper
      end

      def collaborators
        url = "#{@api_helper.api_repo_link}/collaborators"
        response = @api_helper.send_request(url, multipage: true)

        response.map { |user_entry| user_entry.fetch('login') }
      end

      def labels
        url = "#{@api_helper.api_repo_link}/labels"
        response = @api_helper.send_request(url, multipage: true)

        response.map { |label_entry| label_entry['name'] }
      end

      def create_gist(filename, content, description: nil, publik: false)
        Geet::GitHub::Gist.create(filename, content, @api_helper, description: description, publik: publik)
      end

      def create_issue(title, description)
        Geet::GitHub::Issue.create(title, description, @api_helper)
      end

      def abstract_issues(milestone: nil)
        Geet::GitHub::AbstractIssue.list(@api_helper, milestone: milestone)
      end

      def issues
        Geet::GitHub::Issue.list(@api_helper)
      end

      def milestones
        Geet::GitHub::Milestone.list(@api_helper)
      end

      def create_pr(title, description, head)
        Geet::GitHub::PR.create(@local_repository, title, description, head, @api_helper)
      end

      def prs(head: nil)
        Geet::GitHub::PR.list(@api_helper, head: head)
      end
    end
  end
end
