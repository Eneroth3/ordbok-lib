# Ordbok

Ordbok, Swedish for dictionary (literally "wordbook"), is a Ruby library for
localization of SketchUp extensions.

Due to the architecture of SketchUp extensions this library is designed
differently than libraries not meant for SketchUp, e.g. rails/l18n.
As numerous SketchUp extensions run in the same environment, outside of the
developer's control, all code used by an extension (with some exceptions like the
Standard Lib) are supposed to be defined inside the namespace (wrapping module)
of that extension, and be loaded from within that extension's own support
directory.

Some features/concepts that makes Ordbok different from other SketchUp
extension localization libraries, such as TT_Lib2's Babelfish or the shipped
LangHandler, are:

- String Interpolation (supported by Babelfish but not LangHandler)
    - Variables, such as the number of missing files in an error message, can be
    written inside the sentence.
- Descriptive Keys, not English Phrases
    - Less risk of mixing up phrases that happens be homonyms in the original
    language, e.g. the verb Group and the noun Group or Extension (software) and
    Extension (edge style).
    - Allows to specify when the exact same phrase is indeed intended to be
    reused elsewhere, e.g. using the same tool name in both a toolbar and a
    menu.
    - Allows to adjust the original phrase, e.g. correct spelling, without having
    to update the translation tables.
    - Allows for shorter, more readable code when not long sentences need
    to be spelled out.
- Phrase Grouping
    - Organize phrases by what part of the extension use them, or their meaning.
- Pluralization
    - Specify different phrases for singulars and plurals.


## Install

1. Copy files from ``modules/`` into your extension's directory.
2. Replace the wrapping ``OrdbolLib`` module with the wrapping module of your
extension.
3. Require the script(s) from your own extension.

## Usage

See class and method documentation for Ordbok.

TODO: Document how translation tables are saved (for now as JSON files, but that
could change).
