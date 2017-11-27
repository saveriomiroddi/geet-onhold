# frozen_string_literal: true

module Geet
  module Services
    class MergePr
      def execute(repository, output: $stdout)
        merge_head = find_merge_head(repository)
        pr = checked_find_branch_pr(repository, merge_head, output)
        merge_pr(pr, output)
        pr
      end

      private

      def find_merge_head(repository)
        repository.current_branch
      end

      # Expect to find only one.
      def checked_find_branch_pr(repository, head, output)
        output.puts "Finding PR with head (#{head})..."

        prs = repository.prs(head: head)

        raise "Expected to find only one PR for the current branch; found: #{prs.size}" if prs.size != 1

        prs[0]
      end

      def merge_pr(pr, output)
        output.puts "Merging PR ##{pr.number}..."

        pr.merge
      end
    end
  end
end