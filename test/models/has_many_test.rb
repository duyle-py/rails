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

  def test_counting
    assert_equal 3, Firm.first.clients.count
  end

  def test_counting_with_single_hash
    assert_equal 1, Firm.first.plain_clients.where(name: "Apex").count
  end

  def test_find_many_with_merged_options
    cl = Firm.first.limited_clients
    assert_equal 1, cl.size
    assert_equal 1, cl.to_a.size
    assert_equal 3, cl.limit(nil).to_a.size
  end

  def test_find_should_append_to_association_order
    ordered_clients = companies(:first_firm).clients_sorted_desc.order("companies.id asc")
    assert_equal ["id DESC", "companies.id asc"], ordered_clients.order_values
  end

  def test_dynamic_find_should_respect_association_order
    assert_equal companies(:another_first_firm_client), companies(:first_firm).clients_sorted_desc.first
    assert_equal companies(:another_first_firm_client), companies(:first_firm).clients_sorted_desc.find_by_type("Client")
  end

  def test_finding_with_block
    author = Author.find {|a| a.id > 0}
    assert_operator author.posts.count(:id).size, :>, 0
  end

  def test_find_ids
    firm = Firm.first

    assert_kind_of Client, firm.clients.find(2)

    client_arr = firm.clients.find([2, 3])
    assert_kind_of Array, client_arr
    assert_equal 2, client_arr.size

    client_arr = firm.clients.find(2, 3)
    assert_kind_of Array, client_arr
    assert_equal 2, client_arr.size

    assert_raise(ActiveRecord::RecordNotFound) { firm.clients.find(2, 99) }
  end

  def test_find_all_sanitized
    firm = Firm.first
    summit = firm.clients.where("name = 'Summit'").to_a
    assert_equal summit, firm.clients.where("name = ?", "Summit").to_a
    assert_equal summit, firm.clients.where("name = :name", name: "Summit").to_a
  end

  def test_find_grouped
    clients = Client.all.merge!(where: "firm_id = 1").to_a
    assert_equal 3, clients.size

    grouped_clients = Client.all.merge!(where: "firm_id = 1", group: "firm_id", select: "firm_id, count(id) as clients_count").to_a
    assert_equal 1, grouped_clients.size
  end

  def test_find_scope_group
    firm = companies(:first_firm)
    assert_equal 1, firm.clients_grouped_by_id.size
    assert_equal 3, firm.clients_grouped_by_name.size
  end

  def test_find_scoped_grouped_having
    assert_equal 2, authors(:david).popular_grouped_posts.length
    assert_equal 0, authors(:mary).popular_grouped_posts.length
  end

  def test_delete
    clients = companies(:first_firm).clients_of_firm
    assert_equal 2, clients.size
    assert_equal 1, clients.delete(clients.first).size
    assert_equal 1, clients.reload.size
  end
end
