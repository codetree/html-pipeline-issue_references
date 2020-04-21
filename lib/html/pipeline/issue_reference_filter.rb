# frozen_string_literal: true

require 'html/pipeline'
require 'set'

module HTML
  class Pipeline
    class IssueReferenceFilter < Filter
      REPOSITORY_NAME = %r{[a-z0-9][a-z0-9\-]*/[a-z0-9][a-z0-9\-_]*}ix.freeze

      # Match references of the form:
      #
      # - #123
      # - codetree/feedback#123
      # - GH-123
      #
      # See http://rubular.com/r/zM9MJl8SOC
      SHORT_PATTERN = /
        (?<=^|\W)                    # beginning of string or non-word char
        (
          (?:(#{REPOSITORY_NAME})?    # repository name (optional)
          \#|(?:GH\-))(\d+)           # issue number
        )
        (?=
          \.+[ \t\W]|               # dots followed by space or non-word character
          \.+$|                     # dots at end of line
          [^0-9a-zA-Z_.]|           # non-word character except dot
          $                         # end of line
        )
      /ix.freeze

      # Match references of the form:
      #
      # - https://github.com/codetree/feedback/issues/123
      # - https://github.com/codetree/feedback/pulls/123
      URL_PATTERN = %r{
        (?:^|\W)                    # beginning of string or non-word char
        https://github.com/
        (#{REPOSITORY_NAME})        # repository name
        /(?:issues|pulls)/
        (\d+)                       # issue number
        (?=
          \.+[ \t\W]|               # dots followed by space or non-word character
          \.+$|                     # dots at end of line
          [^0-9a-zA-Z_.]|           # non-word character except dot
          $                         # end of line
        )
      }ix.freeze

      # Don't look for mentions in text nodes that are children of these elements
      IGNORE_PARENTS = %w[pre code a style].to_set

      def self.issue_references_in(text)
        text.gsub SHORT_PATTERN do |match|
          repository = Regexp.last_match(2)
          number = Regexp.last_match(3)
          yield match, repository, number
        end
      end

      def default_repo
        context[:repository]
      end

      def call
        doc.search('.//text()').each do |node|
          content = node.to_html
          next if has_ancestor?(node, IGNORE_PARENTS)

          html = issue_reference_filter(content, base_url, default_repo)
          next if html == content

          node.replace(html)
        end

        doc
      end

      def issue_reference_filter(text, _base_url = '/', default_repo = nil)
        self.class.issue_references_in(text) do |match, referenced_repo, number|
          repo = referenced_repo || default_repo
          repo ? link_to_issue(repo, number, default_repo) : match
        end
      end

      def link_to_issue(repo, number, default_repo)
        content = "##{number}"
        content = "#{repo}#{content}" if repo != default_repo

        url = base_url.dup
        url << '/' unless url =~ %r{[/~]\z}
        url << "#{repo}/issues/#{number}"

        "<a href='#{url}' class='issue-reference'>#{content}</a>"
      end
    end
  end
end
