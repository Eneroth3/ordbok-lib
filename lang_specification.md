# Language file specification

Each language is saved as a separate file.
The file extension must be `.lang`.
The file basename should be the IETF language tag or ISO language code if the language has one.
The file must be UTF-8 encoded.
The file must contain a valid JSON string.

The JSON object must have a `name` key, containing an object with a `native` key,
containing the string language name, written in the language itself.

The JSON object must have a `dictionary` key holding an object.
This object may contain any number of phrase strings or nested objects.

# Example

    # scyr.lang
    {
      "name":{
        "native":"Skånska"
      },
      "dictionary":{
        "wheelbarrow":"Rullebör"
      }
    }
