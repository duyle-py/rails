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
class HasManyAssociationsTest < ActiveSupport::TestCase
  def test_sti_subselect_count
    tag = Tag.first
    len = Post.tagged_with(tag.id).limit(10).size
    assert_operator len, :>, 0
  end

  def test_create_from_association_should_respect_default_scope
    car = cars(:honda)

    bulb = Bulb.create
    assert_equal "defaulty", bulb.name

    bulb = car.bulbs.build
    assert_equal "defaulty", bulb.name

    bulb = car.bulbs.create
    assert_equal "defaulty", bulb.name

    bulb = car.bulbs.create!
    assert_equal "defaulty", bulb.name
  end

  def test_create_build_from_association_should_respect_passed_arguments_over_default_scope
    car = Car.create name: "Yamaha"

    bulb = car.bulbs.where(name: "led").build
    assert_equal "led", bulb.name
    assert_equal 0, car.bulbs.unscope(where: :name).count

    bulb = car.bulbs.where(name: "led").create
    assert_equal "led", bulb.name
    assert_equal 1, car.bulbs.unscope(where: :name).count


    bulb = car.bulbs.where(name: "led").create!
    assert_equal "led", bulb.name
    assert_equal 2, car.bulbs.unscope(where: :name).count

    bulb = car.bulbs.build(name: "led")
    assert_equal "led", bulb.name

    bulb = car.bulbs.create(name: "led")
    assert_equal "led", bulb.name

    bulb = car.bulbs.create!(name: "led")
    assert_equal "led", bulb.name

    bulb = car.awesome_bulbs.where(frickinawesome: false).build
    assert_equal false, bulb.frickinawesome

    bulb = car.awesome_bulbs.where(frickinawesome: false).create
    assert_equal false, bulb.frickinawesome

    bulb = car.awesome_bulbs.where(frickinawesome: false).create!
    assert_equal false, bulb.frickinawesome
  end
  def test_create_build_from_association_should_respect_unscoope_over_default_scope
    car = Car.create name: "Honda"

    bulb = car.bulbs.unscope(where: :name).build
    assert_nil bulb.name

    bulb = car.bulbs.unscope(where: :name).create
    assert_nil bulb.name

    bulb = car.bulbs.unscope(where: :name).create!
    assert_nil bulb.name

    bulb = car.awesome_bulbs.unscope(where: :frickinawesome).build
    assert_equal false, bulb.frickinawesome

    bulb = car.awesome_bulbs.unscope(where: :frickinawesome).create
    assert_equal false, bulb.frickinawesome

    bulb = car.awesome_bulbs.unscope(where: :frickinawesome).create!
    assert_equal false, bulb.frickinawesome
  end

  def test_delete_all_on_association_clears_scope
    author = Author.create(name: "Zero")
    essay = author.essays
    new_essay = essay.create!(name: "New Year", writer: author)
    essay.delete_all
    assert_nil essay.first

    assert_not_nil Essay.where(id: new_essay.id)
  end

  def test_building_the_associated_object_with_implicit_sti_base_class
    firm = DependentFirm.new
    company = firm.companies.build
    assert_kind_of Company, company
  end

  def test_building_associated_object_with_explicit_sti_sub_class
    firm = DependentFirm.new
    company = firm.companies.build(type: "Client")
    assert_kind_of Client, company
  end

  def test_build_and_create_for_association_with_an_array_value
    author = Author.create name: "Zero"

    data = [{ body: "Birthday"}, {body: "New Year"}]
    posts = author.posts.where(title: "Happy")
    posts.build(data)

    assert_equal 2, author.posts.size
    author.save

    assert_equal 2, author.posts.count

    posts.create(data)
    assert_equal 4, posts.count

    posts.create!(data)
    assert_equal 6, posts.count

    assert_equal "Happy", posts.first.title
  end

  def test_finder_method_with_dirty_target
    company = companies(:first_firm)

    assert_nil company.clients_of_firm.third
    new_clients = []
    new_clients << company.clients_of_firm.build(name: "Client 1")
    
    assert_equal new_clients[0], company.clients_of_firm.third
  end

  def test_update_all_respect_association_scope
    david = authors(:david)
    posts = david.posts.where(title: "New Title")    
    posts.create body: "Post with new body"

    assert_equal 1, posts.count
    assert_equal 1, posts.update_all(body: "update new body")
  end
end
