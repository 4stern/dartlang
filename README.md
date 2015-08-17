# Dart plugin for Atom

A [Dart](https://www.dartlang.org) plugin for [Atom](https://atom.io).

[![Build Status](https://travis-ci.org/dart-atom/dartlang.svg)](https://travis-ci.org/dart-atom/dartlang)

![Screenshot of Dart plugin in Atom](https://raw.githubusercontent.com/dart-atom/dartlang/master/screenshot.png)

## Installing

- install [Atom](https://atom.io/)
- install the [linter][] package
- install this [dartlang][] package with `apm install dartlang`
- (potentially) configure the location of your Dart SDK

The plugin should auto-detect the Dart SDK location. If not, you can set it
manually in the plugin configuration page (`Preferences > Packages > dartlang`).

### Optional packages

We also recommend the following (optional) packages:

- [last-cursor-position](https://atom.io/packages/last-cursor-position): helps you
  move between cursor location history (useful when using "jump to definition")

- [minimap](https://atom.io/packages/minimap): adds a small preview
  window of the full source code of a file

- [minimap-find-and-replace](https://atom.io/packages/minimap-find-and-replace): displays
  the search matches in the minimap

### Packages to avoid

We do not recommend using both [emmet](https://atom.io/packages/emmet)
and this dartlang package together.
For an unknown reason, editing large .dart files slows down if
you have the emmet plugin installed. We have filed an
[issue](https://github.com/emmetio/emmet-atom/issues/319).

## Features

- auto-discovery of Dart SDK location
- syntax highlighting
- as-you-type errors and warnings
- code completion
- `F1` to see dartdocs
- ctrl-1 / cmd-1 to see quick fixes for errors
- `F3` (or option-click) to jump to definition
- `F4` to see a type hierarchy
- find references to classes and methods
- view type hierarchy
- rename refactoring
- pub commands (get and update) are available via context menus
- format source code with `dartfmt` (use the Command Palette)

A lot of Atom's functionality is surfaced via named commands. You can see all
the available commands by hitting `shift-command-p`.

To view detailed info about what the analysis server is doing, run the
`analysis server status` command.

## Sending feedback

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dart-atom/dartlang/issues

## Developing the plugin

Check out [how to develop][develop].

## Logging

You can change the logging level for the plugin in the config file. Go to
`Atom > Open Your Config` and find the `dartlang` section. Add a
line for `logging`, and set it to a value like `info`, `fine`, `all`, or `none`.
All the values from the `logging` pub package are legal. The log messages will
show up in the devtools console for Atom (`View > Developer > Toggle Developer Tools`).

## License

See the [LICENSE](https://github.com/dart-atom/dartlang/blob/master/LICENSE) file.

[linter]: https://atom.io/packages/linter
[develop]: https://github.com/dart-atom/dartlang/wiki/Developing
[dartlang]: https://atom.io/packages/dartlang
