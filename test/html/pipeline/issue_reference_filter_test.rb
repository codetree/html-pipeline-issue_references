# frozen_string_literal: true

require 'test_helper'

class HTML::Pipeline::IssueReferenceFilterTest < Minitest::Test
  IssueReferenceFilter = HTML::Pipeline::IssueReferenceFilter

  def filter(html, base_url = '/', default_repo = 'foo/bar')
    IssueReferenceFilter.call(html, base_url: base_url, repository: default_repo)
  end

  def test_filtering_a_documentfragment
    body = '<p>Fixes #123</p>'
    doc  = Nokogiri::HTML::DocumentFragment.parse(body)

    res = filter(doc, '/', 'foo/bar')
    assert_same doc, res

    link = '<a href="/foo/bar/issues/123" class="issue-reference">#123</a>'
    assert_equal "<p>Fixes #{link}</p>",
                 res.to_html
  end

  def test_filtering_plain_text
    body = '<p>Fixes #123</p>'
    res  = filter(body, '/', 'foo/bar')

    link = '<a href="/foo/bar/issues/123" class="issue-reference">#123</a>'
    assert_equal "<p>Fixes #{link}</p>",
                 res.to_html
  end

  def test_not_replacing_references_in_pre_tags
    body = '<pre>#123</pre>'
    assert_equal body, filter(body).to_html
  end

  def test_not_replacing_references_in_code_tags
    body = '<p><code>#123</code></p>'
    assert_equal body, filter(body).to_html
  end

  def test_not_replacing_references_in_style_tags
    body = '<style>#123 { color: red; }</style>'
    assert_equal body, filter(body).to_html
  end

  def test_not_replacing_references_in_links
    body = '<p><a>#123</a> okay</p>'
    assert_equal body, filter(body).to_html
  end

  def test_not_replacing_references_without_repo
    body = '<p>Fixes #123</p>'
    res  = filter(body, '/', nil)
    assert_equal body, res.to_html
  end

  def test_including_referenced_repo_when_different_than_default
    body = '<p>Fixes bar/baz#123</p>'
    res  = filter(body, '/', 'foo/bar')

    link = '<a href="/bar/baz/issues/123" class="issue-reference">bar/baz#123</a>'
    assert_equal "<p>Fixes #{link}</p>",
                 res.to_html
  end

  def test_including_referenced_repo_when_default_is_not_set
    body = '<p>Fixes bar/baz#123</p>'
    res  = filter(body, '/', nil)

    link = '<a href="/bar/baz/issues/123" class="issue-reference">bar/baz#123</a>'
    assert_equal "<p>Fixes #{link}</p>",
                 res.to_html
  end

  def test_reference_in_parenthesis
    body = '<p>(#123)</p>'
    res  = filter(body, '/')

    link = '<a href="/foo/bar/issues/123" class="issue-reference">#123</a>'
    assert_equal "<p>(#{link})</p>", res.to_html

    body = '<p>(#123/#456)</p>'
    res  = filter(body, '/')

    link1 = '<a href="/foo/bar/issues/123" class="issue-reference">#123</a>'
    link2 = '<a href="/foo/bar/issues/456" class="issue-reference">#456</a>'
    assert_equal "<p>(#{link1}/#{link2})</p>", res.to_html
  end
end
