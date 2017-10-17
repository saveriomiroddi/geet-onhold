# frozen_string_literal: true

require_relative 'abstract_issue'

module Geet
  module GitHub
    class Issue < AbstractIssue
      def self.create(repository, title, description, api_helper)
        request_address = "#{api_helper.repo_link}/issues"
        request_data = { title: title, body: description, base: 'master' }

        response = api_helper.send_request(request_address, data: request_data)

        issue_number = response.fetch('number')

        new(repository, issue_number, api_helper)
      end

      def link
        "https://github.com/#{@repository.owner}/#{@repository.repo}/issues/#{@issue_number}"
      end
    end
  end
end