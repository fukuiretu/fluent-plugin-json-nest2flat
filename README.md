# fluent-plugin-json-nest, a plugin for [Fluentd](http://fluentd.org)2flat
# Overview

json_nest2flat is a fluentd output plugin.I will convert data into a flat data structure of JSON nested.

ex. {"hoge":1, "foo":2, "data":{"name":"taro", "age":18, "height":175}} -> ex. {"hoge":1, "foo":2, "name":"taro", "age":18, "height":175}

[I am writing in my blog, such as the history of release](http://f-retu.hatenablog.com/entry/2013/12/24/235908)

# Configuration
ex1.

    <match example>
        type json_nest2flat
        tag json_nest2flat.finished
        json_keys data1,data2,data3
    </match>

in

example: {"name":"taro","age":"17","data1":{"a":"b"},"data2":{"c":"d"},"data3":{"e":"f"}}

out

json_nest2flat.finished: {"name":"taro","age":"17","a":"b","c":"d","e":"f"}

ex2.

    <match example>
        type json_nest2flat
        add_tag_prefix json_nest2flat
        json_keys data1,data2,data3
    </match>

in

example: {"name":"taro","age":"17","data1":{"a":"b"},"data2":{"c":"d"},"data3":{"e":"f"}}

out

json_nest2flat.example: {"name":"taro","age":"17","a":"b","c":"d","e":"f"}

ex3.

    <match example>
        type json_nest2flat
        add_tag_prefix json_nest2flat
        json_keys data1
        ignore_item_keys {"data1":["b","c","d"]}
    </match>

in

example: {"name":"taro","age":"17","data1":{"a":"b","b":"c","c":"d","d":"e","e":"f"}}

out

json_nest2flat.example: {"name":"taro","age":"17","a":"b","e":"f"}

# Parameters
* tag

    The output tag. add_tag_prefix or tag is required.

* add_tag_prefix

    To add a prefix to the tag that matched. Tag, is enabled if both are specified tag and if, add_tag_prefix is ignored.

* json_keys

    It is the key that you want to convert to a flat structure from JSON nested. It is more than one can be specified in a comma-separated.

* ignore_item_keys

    You specify the item that you want to ignore the key that is specified in the "json_keys". The format is JSON format. Please refer to the section of "Configuration" example of setting.
    

# TODO

 Currently, nested structure of two or more layers will be unexpected.
 
# Copyright
Copyright:: Copyright (c) 2013- fukuiretu License:: Apache License, Version 2.0
