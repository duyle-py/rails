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

  def test_has_many_primary_key_polymorphic
    david = authors(:david)
    assert_not_predicate david.essays_2, :loaded?

    assert_equal Essay.where(writer_id: 1), david.essays_2
  end

  def test_ids_on_association
    david = people(:david)

    assert_equal Essay.where(writer_id: 1).pluck(:id), david.essay_ids
  end

  def test_has_many_assignment
    author = authors(:david)
    david = people(:david)

    assert_equal ["A Modest Proposal", "Stay Home"], david.essays.map(&:name)
    david.essays = [Essay.create!(name: "Remote Work", author: author, writer: david)]
    assert_equal ["Remote Work"], david.essays.map(&:name)
  end

  def test_blank_record
    author = Author.new
    assert_not_predicate author.essays, :loaded?
    assert_equal 0, author.essays.size
  end
end
