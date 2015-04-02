fluent-plugin-random
====================

(Yet another Fluentd plugin)

What
----

Allows to replace generate random value (only in integer at the time of this README) in a the specified key.

How
---

You want to define :
- Output field : **field**.
- Integer interval : **integer** (syntax is the Ruby range..syntax)

More random type could come in the future (float, string)

Examples
========

Example 0
---------

```
<match *.test>
    type random
    add_tag_prefix random.
    integer 15..100
    field key1
</match>
```

Example of records :
```
{
    'foo' => "bar"
}
```
... *can* output :
```
{
    'key1' => 42,
    'foo' => "bar"
}
```
