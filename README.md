[zaru_crystal](https://github.com/szTheory/zaru_crystal)
====
[![Build Status](https://travis-ci.org/szTheory/zaru_crystal.svg?branch=master)](https://travis-ci.org/szTheory/zaru_crystal) [![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://sztheory.github.io/zaru_crystal/) [![GitHub release](https://img.shields.io/github/release/szTheory/zaru_crystal.svg)](https://github.com/szTheory/zaru_crystal/releases)

Filename sanitization for Crystal. This is useful when you generate filenames for downloads from user input. Port of the [Zaru gem for Ruby](https://github.com/madrobby/zaru). 

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
 dependencies:
   zaru_crystal:
     github: szTheory/zaru_crystal
```

2. Run `shards install`

## Usage

```crystal
require "zaru_crystal"
```

```crystal
Zaru.sanitize! "  what\ēver//wëird:user:înput:"
# => "whatēverwëirduserînput"
```

Zaru takes a given filename (a string) and normalizes, filters and truncates it.

It removes the bad stuff but leaves unicode characters in place, so users can use whatever alphabets they want to. Zaru also doesn't remove whitespace– instead, any sequence of whitespace that is 1 or more characters in length is collapsed to a single space. Filenames are truncated so that they are at maximum 255 characters long.

If extra breathing room is required (for example to add your own filename extension later),
you can leave extra room with the `:padding` option:

```crystal
Zaru.sanitize! "A"*400, padding: 100
# resulting filename is 145 characters long
```

If you need to customize the fallback filename you can add your own fallback
with the `:fallback` option:

```crystal
Zaru.sanitize! "<<<", fallback: "no_file"
# resulting filename is "no_file"
```

Bad things in filenames
-----------------------

Wikipedia has a [good overview on filenames](http://en.wikipedia.org/wiki/Filename). Basically, on modern-ish operating systems, the following characters  are considered no-no (Zaru filters these):

```
/ \ ? * : | " < >
```

Additionally the [ASCII control characters](http://en.wikipedia.org/wiki/ASCII#ASCII_control_characters) (hexadecimal `00` to `1f`) are filtered.

All [Unicode whitespace](http://en.wikipedia.org/wiki/Whitespace_character#Unicode) at the beginning and end of the potential filename is removed, and any Unicode whitespace within the filename is collapse to a single space character.

[Certain filenames are reserved in Windows](http://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx) and are filtered.

TODO
----

* Extend test suite

[Wait, what, Zaru?](http://en.wikipedia.org/wiki/Zaru)

[zaru_crystal](https://github.com/szTheory/zaru_crystal) is licensed under the terms of the MIT license.