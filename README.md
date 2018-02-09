# Ordbok

Ordbok, Swedish for dictionary (literally "wordbook"), is a Ruby library for
localization of SketchUp extensions.

As numerous SketchUp extensions can run in the same environment, outside of the
developers control, Ordbok is designed to run differently than e.g. rails/l18n.
Ordbok is designed to be defined by each extensions using it, within the
extension's own namespace, and be loaded from inside of the extension's own
directory.

This prevents any possible issues of different extensions requiring different
versions of the library, and lets the end user use the extensions without having
to handle dependencies manually.

Ordbok is designed to look up strings using descriptive keys, rather than
the original English phrases, to prevent errors due to misspelling or different
phrasing and to allow for completely different phrases to spell out as the same
string without being mixed up in translation (e.g. the verb 'group' and noun
'group').

Ordbok focuses on languages, not units, date formats or the like. Units are
defined on a per model basis in SketchUp. Decimal separator is defined on an OS
level. And dates should frankly be written according to international standards,
regardless of locale.

TODO: Add license.
TODO: Simplify and clarify readme. Include these key features:
- Interpolation
- descriptive keys, not English strings
- String grouping
- pluralization

## Install

1. Copy from ``modules/`` into your extension's directory.
2. Replace the wrapping ``OrdbolLib`` module with the wrapping module of your
extension.
3. Require the script(s) from your own extension.

## Usage

See documentation class and method documentation for Ordbok.
