fluent-plugin-randomtag
====================

Appends a random int to the start of a tag

How
---

You want to define :
- Integer interval : **integer** (syntax is the Ruby range..syntax)


Examples
========

Example 0
---------

```
<match *.test>
    type randomtag
    integer 15..100
</match>
```

Example of records :
```
logInput
{
    'foo' => "bar"
}
```
... *can* output :
```
1.logInput
{
    'foo' => "bar"
}
```
