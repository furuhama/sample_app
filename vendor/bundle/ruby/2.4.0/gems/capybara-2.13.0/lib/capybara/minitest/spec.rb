require 'minitest/spec'

module Capybara
  module Minitest
    module Expectations
      %w(text content title current_path).each do |assertion|
        infect_an_assertion "assert_#{assertion}", "must_have_#{assertion}", :reverse
        infect_an_assertion "refute_#{assertion}", "wont_have_#{assertion}", :reverse
      end

      # Unfortunately infect_an_assertion doesn't pass through the optional filter block so we can't use it for these
      %w(selector xpath css link button field select table checked_field unchecked_field).each do |assertion|
        self.class_eval <<-EOM
          def must_have_#{assertion} *args, &optional_filter_block
            ::Minitest::Expectation.new(self, ::Minitest::Spec.current).must_have_#{assertion}(*args, &optional_filter_block)
          end

          def wont_have_#{assertion} *args, &optional_filter_block
            ::Minitest::Expectation.new(self, ::Minitest::Spec.current).wont_have_#{assertion}(*args, &optional_filter_block)
          end
        EOM

        ::Minitest::Expectation.class_eval <<-EOM, __FILE__, __LINE__ + 1
          def must_have_#{assertion} *args, &optional_filter_block
            ctx.assert_#{assertion}(target, *args, &optional_filter_block)
          end

          def wont_have_#{assertion} *args, &optional_filter_block
            ctx.refute_#{assertion}(target, *args, &optional_filter_block)
          end
        EOM
      end

      %w(selector xpath css).each do |assertion|
        self.class_eval <<-EOM
          def must_match_#{assertion} *args, &optional_filter_block
            ::Minitest::Expectation.new(self, ::Minitest::Spec.current).must_match_#{assertion}(*args, &optional_filter_block)
          end

          def wont_match_#{assertion} *args, &optional_filter_block
            ::Minitest::Expectation.new(self, ::Minitest::Spec.current).wont_match_#{assertion}(*args, &optional_filter_block)
          end
        EOM

        ::Minitest::Expectation.class_eval <<-EOM, __FILE__, __LINE__ + 1
          def must_match_#{assertion} *args, &optional_filter_block
            ctx.assert_matches_#{assertion}(target, *args, &optional_filter_block)
          end

          def wont_match_#{assertion} *args, &optional_filter_block
            ctx.refute_matches_#{assertion}(target, *args, &optional_filter_block)
          end
        EOM
      end

      ##
      # Expectation that there is xpath
      #
      # @!method must_have_xpath
      #   see Capybara::Node::Matchers#has_xpath?

      ##
      # Expectation that there is no xpath
      #
      # @!method wont_have_xpath
      #   see Capybara::Node::Matchers#has_no_xpath?

      ##
      # Expectation that there is css
      #
      # @!method must_have_css
      #   see Capybara::Node::Matchers#has_css?

      ##
      # Expectation that there is no css
      #
      # @!method wont_have_css
      #   see Capybara::Node::Matchers#has_no_css?

      ##
      # Expectation that there is link
      #
      # @!method must_have_link
      #   see {Capybara::Node::Matchers#has_link?}

      ##
      # Expectation that there is no link
      #
      # @!method wont_have_link
      # see {Capybara::Node::Matchers#has_no_link?}

      ##
      # Expectation that there is button
      #
      # @!method must_have_button
      #   see {Capybara::Node::Matchers#has_button?}

      ##
      # Expectation that there is no button
      #
      # @!method wont_have_button
      #   see {Capybara::Node::Matchers#has_no_button?}

      ##
      # Expectation that there is field
      #
      # @!method must_have_field
      #   see {Capybara::Node::Matchers#has_field?}

      ##
      # Expectation that there is no field
      #
      # @!method wont_have_field
      #   see {Capybara::Node::Matchers#has_no_field?}

      ##
      # Expectation that there is checked_field
      #
      # @!method must_have_checked_field
      #   see {Capybara::Node::Matchers#has_checked_field?}

      ##
      # Expectation that there is no checked_field
      #
      # @!method wont_have_chceked_field

      ##
      # Expectation that there is unchecked_field
      #
      # @!method must_have_unchecked_field
      #   see {Capybara::Node::Matchers#has_unchecked_field?}

      ##
      # Expectation that there is no unchecked_field
      #
      # @!method wont_have_unchceked_field

      ##
      # Expectation that there is select
      #
      # @!method must_have_select
      #   see {Capybara::Node::Matchers#has_select?}

      ##
      # Expectation that there is no select
      #
      # @!method wont_have_select
      #   see {Capybara::Node::Matchers#has_no_select?}

      ##
      # Expectation that there is table
      #
      # @!method must_have_table
      #   see {Capybara::Node::Matchers#has_table?}

      ##
      # Expectation that there is no table
      #
      # @!method wont_have_table
      #   see {Capybara::Node::Matchers#has_no_table?}

      ##
      # Expectation that page title does match
      #
      # @!method must_have_title
      #   see {Capybara::Node::DocumentMatchers#assert_title}

      ##
      # Expectation that page title does not match
      #
      # @!method wont_have_title
      #   see {Capybara::Node::DocumentMatchers#assert_no_title}

      ##
      # Expectation that current path matches
      #
      # @!method must_have_current_path
      #   see {Capybara::SessionMatchers#assert_current_path}

      ##
      # Expectation that current page does not match
      #
      # @!method wont_have_current_path
      #   see {Capybara::SessionMatchers#assert_no_current_path}

    end
  end
end

class Capybara::Session
  include Capybara::Minitest::Expectations unless ENV["MT_NO_EXPECTATIONS"]
end

class Capybara::Node::Base
  include Capybara::Minitest::Expectations unless ENV["MT_NO_EXPECTATIONS"]
end

class Capybara::Node::Simple
  include Capybara::Minitest::Expectations unless ENV["MT_NO_EXPECTATIONS"]
end
