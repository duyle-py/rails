require "test_helper"

class HasManyAssociationsTestPrimaryKeys < ActiveSupport::TestCase
  def test_custom_primary_key_on_new_record_should_fetch_with_query
    subscriber = Subscriber.new(nick: "webster132")
    assert_not_predicate subscriber.subscriptions, :loaded?

    assert_equal 2, subscriber.subscriptions.size

    assert_equal Subscription.where(subscriber_id: "webster132"), subscriber.subscriptions
  end

  def test_association_primary_key_on_new_record_should_fetch_with_query
    author = Author.find(1)
    assert_not_predicate author.essays, :loaded?

    assert_equal 1, author.essays.size

    assert_equal Essay.where(author_id: 1), author.essays
  end
end
