require 'test_helper'

# Defined this as a ActionController test so we can actually
# perform requests which is required by some helper methods but
# also forces us to manually include the helper.
class ApplicationHelperTest < ActionController::TestCase
  include ApplicationHelper
  include ActionView::Helpers::CaptureHelper
  tests Frontend::HomeController

  test "a correct body class should be generated" do
    get :index

    self.class_eval { attr_reader :controller }
    assert_equal "frontend home index", generate_body_class
  end

  # TODO: test title
end
