# fluent-plugin-json-nest2flat
# Overview

json_nest2flat is a fluentd output plugin.
I will convert data into a flat data structure of JSON nested.

ex. {“hoge”:1, “foo”:2, “data”:{"name":"taro", "age":18, "height":175}} -> ex. {“hoge”:1, “foo”:2, "name":"taro", "age":18, "height":175}


# Configuration

    <match pattern>
        type json_nest2flat
        json_keys data1,data2,data3
    </match>

# Parameters
* json_keys

    It is the key that you want to convert to a flat structure from JSON nested. It is more than one can be specified in a comma-separated.
    
# TODO

 Currently, nested structure of two or more layers will be unexpected.
 
# Copyright
Copyright:: Copyright (c) 2013- fukuiretu License:: Apache License, Version 2.0
