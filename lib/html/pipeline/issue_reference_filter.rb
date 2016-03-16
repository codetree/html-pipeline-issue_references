require "html/pipeline"
require "set"

module HTML
  class Pipeline
    class IssueReferenceFilter < Filter
      VERSION = "0.1.0".freeze

      REPOSITORY_NAME = /[a-z0-9][a-z0-9\-]*\/[a-z0-9][a-z0-9\-_]*/ix

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
      /ix

      # Match references of the form:
      #
      # - https://github.com/codetree/feedback/issues/123
      # - https://github.com/codetree/feedback/pulls/123
      URL_PATTERN = /
        (?:^|\W)                    # beginning of string or non-word char
        https:\/\/github.com\/
        (#{REPOSITORY_NAME})        # repository name
        \/(?:issues|pulls)\/
        (\d+)                       # issue number
        (?=
          \.+[ \t\W]|               # dots followed by space or non-word character
          \.+$|                     # dots at end of line
          [^0-9a-zA-Z_.]|           # non-word character except dot
          $                         # end of line
        )
      /ix

      # Don't look for mentions in text nodes that are children of these elements
      IGNORE_PARENTS = %w(pre code a style).to_set

      def self.issue_references_in(text)
        text.gsub SHORT_PATTERN do |match|
          repository = $2
          number = $3
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

      def issue_reference_filter(text, base_url = '/', default_repo = nil)
        self.class.issue_references_in(text) do |match, referenced_repo, number|
          repo = referenced_repo || default_repo
          repo ? link_to_issue(repo, number, default_repo) : match
        end
      end

      def link_to_issue(repo, number, default_repo)
        content = "##{number}"
        content = "#{repo}#{content}" if repo != default_repo

        url = base_url.dup
        url << "/" unless url =~ /[\/~]\z/
        url << "#{repo}/issues/#{number}"

        "<a href='#{url}' class='issue-reference'>#{content}</a>"
      end
    end
  end
end
