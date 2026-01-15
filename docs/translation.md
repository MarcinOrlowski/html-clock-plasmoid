![HTML Clock for Plasma](../img/banner.png)

---

# Translation Guide

The HTML Clock widget supports localization of the settings UI. This guide explains how to contribute translations and test them.

## For Translators

### Creating a New Translation

1. Copy the template file to create your language file:
   ```bash
   cd src/translate
   cp template.pot <language_code>.po
   ```
   Use standard locale codes like `nl` (Dutch), `de` (German), `fr` (French), etc.

2. Edit the `.po` file header:
   ```
   "Language: <language_code>\n"
   "Last-Translator: Your Name <your@email.com>\n"
   ```

3. Translate each `msgstr` entry:
   ```
   msgid "General"
   msgstr "Algemeen"
   ```

4. Submit your `.po` file via a pull request to the repository.

### Updating an Existing Translation

If new strings were added to `template.pot`, update your `.po` file by adding the new `msgid`/`msgstr` pairs manually.

## For Developers

### Building Translations

After adding or updating `.po` files, compile them to binary `.mo` format:

```bash
cd src/translate
./build.sh
```

This creates `.mo` files in `src/contents/locale/<lang>/LC_MESSAGES/`.

### Adding New Translatable Strings

When adding new user-visible strings to QML files:

1. Wrap the string with `i18n()`:
   ```qml
   text: i18n("My new string")
   ```

2. Add the string to `src/translate/template.pot`:
   ```
   #: contents/ui/config/MyFile.qml
   msgid "My new string"
   msgstr ""
   ```

### Testing Translations

1. Build the translations:
   ```bash
   cd src/translate
   ./build.sh
   ```

2. Install the widget:
   ```bash
   kpackagetool6 -t Plasma/Applet --upgrade ./src
   ```

3. Test with a specific locale:
   ```bash
   LANGUAGE="pl:pl_PL" LANG="pl_PL.UTF-8" plasmoidviewer -a com.marcinorlowski.htmlclock
   ```

   Replace `pl` with your target language code.

4. Open widget settings to verify translated strings.

## File Structure

```
src/
├── translate/
│   ├── template.pot      # Translation template (source of truth)
│   ├── pl.po             # Polish translation
│   ├── build.sh          # Compiles .po to .mo
│   └── <lang>.po         # Other language translations
└── contents/
    └── locale/
        └── <lang>/
            └── LC_MESSAGES/
                └── plasma_applet_com.marcinorlowski.htmlclock.mo
```

## Available Translations

Most translations are machine-generated. Improvements and corrections are welcome!

| Language              | Code  |
|-----------------------|-------|
| Chinese (Simplified)  | zh_CN |
| Czech                 | cs    |
| Dutch                 | nl    |
| Estonian              | et    |
| French                | fr    |
| German                | de    |
| Italian               | it    |
| Japanese              | ja    |
| Norwegian (Bokmål)    | nb    |
| Polish                | pl    |
| Portuguese (Brazil)   | pt_BR |
| Spanish               | es    |
| Swedish               | sv    |
| Ukrainian             | uk    |

### Improving Existing Translations

If you notice translation errors or want to improve wording:

1. Edit the corresponding `.po` file in `src/translate/`
2. Submit a pull request with your changes

Even small fixes are appreciated!
