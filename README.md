# Ordbok

Ordbok, Swedish for dictionary ("wordbook"), is a Ruby library for localisation.

The library is specifically designed to be used for SketchUp extensions.
This means scopes, namespaces and loading differs from other Ruby envirements.
In SketchUp all loaded extension run in the same envirement, with modules
wrapping them to avoid name collision. This library is designed to live
within such a module and not be shared between extensions, as different
extensions may require different versions of the library.

Keys are descriptive symbols rather than exact strings for more readable source code,
less risk of errors (harder to misspell or forget a word) and to not mix up different
phrases that merely happens to spell out the same in the original language, e.g.
"Group" (verb) and "Group" (noun), or "Extension" (software) or "Extension"
(lines rendered longer than their actual size).

Ordbok focuses on languages, not units, date formats or the like. Units is defined
on a per model basis. Dates should be written according to international standards.