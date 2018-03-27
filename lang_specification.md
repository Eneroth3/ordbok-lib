# Language file specification

Each language is saved as a separate file.
The file extension must be `.lang`.
The file basename should be the IETF language tag or ISO language code if the language has one.
The file must be UTF-8 encoded.
The file must contain a valid JSON string.

The JSON object must have a `name` key, containing an object with a `native` key,
containing the string language name, written in the language itself.

The JSON object may have a `pluralization_rule` key containing one of the following strings:

* "one_other" (used e.g in English, German, Italian, Spanish and Swedish)
* "one_upto_two_other" (used e.g in French and Portuguese),
* "east_slavic" (used e.g. in Russian)
* "polish"
* "welsh" (not available as SketchUp language but I liked the rules)

The default value is "one_other".

The JSON object must have a `dictionary` key holding an object.
This object may contain any number of _entries_ or _nested objects_.

A _nested object_ may contain any number of _entries_ or _nested objects_.

An _entry_ must be either a string or an object containing strings using different pluralization.
Valid keys within an entry are "zero", "one", "few", "many" and "other".
The meaning of these keys are defined by [UCDR](http://www.unicode.org/cldr/charts/29/supplemental/language_plural_rules.html)

# Example

    # scyr.lang
    {
      "name":{
        "native":"Skånska"
      },
      "dictionary":{
        "wheelbarrow":"Rullebör",
        "slide":{
          "one":"Kasebana",
          "other":"Kasebanor"
        }
      }
    }
