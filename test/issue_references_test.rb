require 'test_helper'

class HTML::Pipeline::IssueReferencesTest < Minitest::Test
  IssueReferenceFilter = HTML::Pipeline::IssueReferenceFilter

  def test_that_it_has_a_version_number
    refute_nil HTML::Pipeline::IssueReferences::VERSION
  end

  
end
