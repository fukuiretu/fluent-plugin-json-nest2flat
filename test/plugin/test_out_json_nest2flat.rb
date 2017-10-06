require 'test/unit'
require 'fluent/test'
require 'fluent/plugin/out_json_nest2flat'

class JsonNestToFlatOutputTest < Test::Unit::TestCase

  def setup
    Fluent::Test.setup
  end

  def create_driver(conf, tag = 'test')
    Fluent::Test::OutputTestDriver.new(Fluent::JsonNestToFlatOutput, tag).configure(conf)
  end

  CONFIG = %[
    tag fluent.test
    add_tag_prefix prefix
    json_keys key1,key2
    ignore_item_keys {"data1":["b","c","d"]}
  ]

  def test_configure
    d = create_driver(CONFIG)
    assert_equal 'fluent.test', d.instance.tag
    assert_equal 'prefix', d.instance.add_tag_prefix
    assert_equal ['key1', 'key2'], d.instance.json_keys
    assert_equal JSON.parse('{"data1":["b","c","d"]}'), d.instance.ignore_item_keys
  end

  def test_emit
    d = create_driver(%[
      tag json_nest2flat.finished
      json_keys data1,data2,data3
    ])

    d.run { d.emit({"name" =>"taro",
                    "age" => "17",
                    "data1" => {"a" => "b"},
                    "data2" => {"c" => "d"},
                    "data3" => {"e" => "f"}}) }

    emits = d.emits
    expected = {"name"=>"taro", "age"=>"17", "a"=>"b", "c"=>"d", "e"=>"f"}
    assert_equal 'json_nest2flat.finished', emits[0][0]
    assert_equal expected, emits[0][2]
  end

  def test_emit_add_tag_prefix
    d = create_driver(%[
      add_tag_prefix json_nest2flat
      json_keys data1,data2,data3
    ], 'example')

    d.run { d.emit({"name" =>"taro",
                    "age" => "17",
                    "data1" => {"a" => "b"},
                    "data2" => {"c" => "d"},
                    "data3" => {"e" => "f"}}) }

    emits = d.emits
    expected = {"name"=>"taro", "age"=>"17", "a"=>"b", "c"=>"d", "e"=>"f"}
    assert_equal 'json_nest2flat.example', emits[0][0]
    assert_equal expected, emits[0][2]
  end

  def test_emit_ignore_item_keys
    d = create_driver(%[
      add_tag_prefix json_nest2flat
      json_keys data1
      ignore_item_keys {"data1":["b","c","d"]}
    ], 'ignore_keys')

    d.run { d.emit({"name" => "taro",
                    "age" => "17",
                    "data1" => {"a" => "b",
                                "b" => "c",
                                "c" => "d",
                                "d" => "e",
                                "e" => "f"}}) }

    emits = d.emits
    expected = {"name"=>"taro", "age"=>"17", "a"=>"b", "e"=>"f"}
    assert_equal 'json_nest2flat.ignore_keys', emits[0][0]
    assert_equal expected, emits[0][2]
  end
end
