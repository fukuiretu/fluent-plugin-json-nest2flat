# fluent-plugin-json-nest2flat
# Overview

json_nest2flat is a fluentd output plugin.I will convert data into a flat data structure of JSON nested.

ex. {"hoge":1, "foo":2, "data":{"name":"taro", "age":18, "height":175}} -> ex. {"hoge":1, "foo":2, "name":"taro", "age":18, "height":175}

[I am writing in my blog, such as the history of release](http://f-retu.hatenablog.com/entry/2013/12/24/235908)

# Configuration
ex1.

    <match pattern>
        type json_nest2flat
        tag json_nest2flat.finished
        json_keys data1,data2,data3
    </match>


ex2.

    <match pattern>
        type json_nest2flat
        add_tag_prefix json_nest2flat
        json_keys data1,data2,data3
    </match>

# Parameters
* tag

    The output tag. add_tag_prefix or tag is required.

* add_tag_prefix

    To add a prefix to the tag that matched. Tag, is enabled if both are specified tag and if, add_tag_prefix is ignored.

* json_keys

    It is the key that you want to convert to a flat structure from JSON nested. It is more than one can be specified in a comma-separated.

# TODO

 Currently, nested structure of two or more layers will be unexpected.
 
# Copyright
Copyright:: Copyright (c) 2013- fukuiretu License:: Apache License, Version 2.0
