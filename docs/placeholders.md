![HTML Clock for Plasma](../img/banner.png)

---

## Table of Contents ##

* [Configuration](configuration.md)
* [Placeholders](placeholders.md)
  * [Date and Time](#date-and-time)
  * [Formatting directives](#formatting-directives)
  * [Special placeholders](#special-placeholders)
* [Tips and tricks](tips.md)
* [Installation and upgrading](installation.md)

---

## Placeholders ##

Both HTML layout or tooltip string can contain anything you like, however certain sequences are
considered
placeholders, and will be replaced by corresponding values, all other elements are returned
unaltered.

### Date and Time ###

These are date and time related, and will return values based on your current calendar/clock and
system timezone settings.

| Placeholder | Description                                                        |
|-------------|--------------------------------------------------------------------|
| {yyyy}      | long year (i.e. "2009")                                            |
| {yy}        | short year (i.e. "09")                                             |
| {MMM}       | long month name (i.e. "January")                                   |
| {MM}        | abbreviated (locale based) month name (i.e. "Jan")                 |
| {M}         | first letter of month name (i.e. "J")                              |
| {mm}        | zero prefixed 2 digit month number ("02" for Feb, "12" for Dec)    |
| {m}         | month number as is ("2" for Feb, "12" for Dec)                     |
| {DDD}       | full day name (i.e. ""Saturday", "Sunday", "Monday")               |
| {DD}        | abbreviated day name, locale based (**usually** 3, but can be 1-6 chars) |
| {D}         | one letter day name ("S", "S", "M")                                |
| {dd}        | zero prefixed 2 digit day number ("01", "27")                      |
| {d}         | day number as is ("1", "27")                                       |
| {wy}        | week of year, ISO 8601 ("1" to "53")                               |
| {hh}        | current hour, zero prefixed, 24hrs clock (i.e. "01", "16")         |
| {h}         | current hour, 24hrs clock (i.e. "1", "16")                         |
| {kk}        | current hour, zero prefixed, 12hrs clock (i.e. "01", "11")         |
| {k}         | current hour, 12hrs clock (i.e. "1", "11")                         |
| {ii}        | current minute, zero prefixed (i.e. "01", "35")                    |
| {i}         | current minute (i.e. "1", "35")                                    |
| {ss}        | current second, zero prefixed (i.e. "01", "35") <sup>v1.1.0+</sup> |
| {s}         | current second (i.e. "1", "35") <sup>v1.1.0+</sup>                 |
| {AA}        | upper-cased AM/PM marker (i.e. "AM")                               |
| {A}         | upper-cased abbreviated AM/PM marker. "A" for "AM", "P" for "PM"   |
| {aa}        | lower-cased am/pm marker (i.e. "am")                               |
| {a}         | lower-cased abbreviated AM/PM marker. "a" for "am", "p" for "pm"   |
| {Aa}        | AM/PM marker with first letter uppercased (i.e. "Am"/"Pm")         |
| {t}         | Timezone name (i.e. "UTC")                                         
| {ldl}       | Locale based date long format <sup>v1.1.0+</sup>                   |
| {lds}       | Locale based date short format <sup>v1.1.0+</sup>                  |
| {ltl}       | Locale based time long format <sup>v1.1.0+</sup>                   |
| {lts}       | Locale based time short format <sup>v1.1.0+</sup>                  |
| {ldtl}      | Locale based date and time long format <sup>v1.1.0+</sup>          |
| {ldts}      | Locale based date and time short format <sup>v1.1.0+</sup>         |

For example, `Today is {DDD}` will produce `Today is Sunday` (assuming today is named "Sunday").

### Formatting directives ###

You can also use optional formatting directives. The syntax is `{PLACEHOLDER|DIRECTIVE}`:

| Directive | Description                                                                                                                                                                                                                                                                                                                         |
|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| U         | Turns whole placeholder uppercased (i.e. `{DD\|U}` => "SAT")                                                                                                                                                                                                                                                                         |
| L         | Turns whole placeholder lowercased (i.e. `{DD\|L}` => "sat")                                                                                                                                                                                                                                                                         |
| u         | Turns first letter of placeholder uppercased, leaving remaining part unaltered. This is useful when i.e. weekday or month names are usually lowercased in your language but you'd like to have it other way. I.e. for Polish localization, `{DDD}` can produce "wtorek" for Tuesday. With `{DDD\|u}` you would get "Wtorek" instead. |
| 00        | Ensures placeholder value is at last two **characters** (not just digits!) long by adding leading zeros to shorter strings. Longer strings will not be trimmed. Also note zeroes will be prepended unconditionally, even if that would make no much sense, i.e. `{D\|00}` produce `0M` on Mondays.                                   |

> ![Warning](img/warning.png) **NOTE:** at the moment, formatting directives cannot be combined.

### Timezone offset ###

You can display time in a different timezone by adding a timezone offset to time-related placeholders.
This feature requires the `|` separator (not `:`).

The syntax is `{PLACEHOLDER|[+-]HH:MM}` where `[+-]HH:MM` is the UTC offset:

| Example | Description |
|---------|-------------|
| `{hh\|+00:00}:{ii\|+00:00}` | UTC time |
| `{hh\|+05:30}:{ii\|+05:30}` | India Standard Time (UTC+5:30) |
| `{hh\|-05:00}:{ii\|-05:00}` | US Eastern Time (UTC-5) |
| `{hh\|+09:00}:{ii\|+09:00}` | Japan Standard Time (UTC+9) |

You can also combine timezone offset with a formatting directive:

```html
{hh|+00:00|00}:{ii|+00:00|00}  <!-- UTC time, zero-padded -->
```

This allows showing multiple timezones in a single layout (world clock):

```html
<table>
  <tr>
    <td style="padding-right: 10px;">
      <span style="font-size: 12px; color: gray;">New York</span><br/>
      <span style="font-size: 24px;">{hh|-05:00}:{ii|-05:00}</span>
    </td>
    <td style="padding-left: 10px;">
      <span style="font-size: 12px; color: gray;">Tokyo</span><br/>
      <span style="font-size: 24px;">{hh|+09:00}:{ii|+09:00}</span>
    </td>
  </tr>
</table>
```

### Special placeholders ###

These are extra placeholders that are implemented to work around limitation of QT's supported
HTML/CSS.

| Placeholder    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                            |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| {flip\|XX\|YY} | Alternates between `XX` and `YY` values at configurable interval (see "Flip interval" in General settings, default 1000ms). This can be used to do some animation or other [tricks](#tips-and-tricks). Both `XX` and `YY` can be almost any text you want and can be used in any place of your layout, so you can flip **parts** of your CSS style, HTML markup or **even flip other placeholders**, as `{flip}` is always processed separately as first one. |
| {cycle\|A\|B\|C\|...} | Cycles through multiple values at configurable interval. Similar to `{flip}` but supports more than 2 values. Example: `{cycle|1|2|3|4}` produces 1, 2, 3, 4, 1, 2... See [traffic light example](#traffic-light). |

> ![Warning](img/warning.png) **NOTE:** `{flip}` and `{cycle}` cannot be nested into each other.

---

## Tips and tricks ##

* QT support for HTML and CSS is not covering all features available, so here are some tricks you
  can pull to achieve effects often desired while creating new clock.
* Want custom background color for your widget? Just ensure your template uses `<body>` tag and set
  its  `bgcolor` as you like. Remember that you also need to enable either `Container fill width` or
  `Container fill height` depending on your desired orientation.
* To get 100% in vertical orientation, set `<BODY>`'s `width` attribute to `100%` (i.e.
  `<body width="100%">`) or use CSS

### Blinking ###

Blinking seconds (usually shown in a form of blinking `:` separator placed between hours and
minutes). Unfortunately we cannot use CSS animators here as these are not supported by QT
implementation. But we can do some smart tricks with text colors, as fortunately for us, QT supports
CSS colors as well as its alpha channel (aka transparency). So to make thing blink, we will be
simply cycling between fully transparent and fully opaque. To achieve that effect, you need to use
special placeholder called `{flip|XX|YY}`, which alternates between `XX` and `YY` at the configured
flip interval (default 1000ms, configurable in General settings).

#### Examples ####

Knowing that CSS color format is `#AARRGGBB` where `AA` is alpha channel value from `00` being fully
transparent to `FF` (255 in decimal) being fully opaque, we can do this:

```html
<span style="color: #{flip|00|FF}ffffff;">BLINK!</span>
```

![Flipping alpha channel value](img/flip-01.gif)

But if you want, you can also blink by toggling whole colors:

```html
<span style="color: {flip|#ff0000|#00ff00};">BLINK!</span>
```

or by
using [QT supported SVG color names](https://doc.qt.io/qt-6/qml-color.html#svg-color-reference):

```html
<span style="color: {flip|red|green};">BLINK!</span>
```

You can use `{flip}` as many times as you want, so you can easily achieve this:

```html
<span style="color: {flip|#ff0000|green};">{flip|THIS|BLINKS}!</span>
```

![Flip example 02](img/flip-02.gif)

As already mentioned, you can also flip other placeholders:

```html
{flip|{MMM} {dd}, {yy}|Today is {DDD}}
```

![Flip example 03](img/flip-03.gif)

### Traffic light ###

Using `{cycle}` you can create animations with more than 2 states. Here's a 3x3 grid with a
diagonal wave effect using 10 color values per cell, creating a smooth flowing animation:

```html
<table align="center" style="border-spacing: 4px;">
  <tr>
    <td><span style="font-size: 28px; color: {cycle|#FF0000|#FF4400|#FF8800|#FFCC00|#FFFF00|#88FF00|#00FF00|#00FF88|#00FFFF|#0088FF};">●</span></td>
    <td><span style="font-size: 28px; color: {cycle|#0088FF|#FF0000|#FF4400|#FF8800|#FFCC00|#FFFF00|#88FF00|#00FF00|#00FF88|#00FFFF};">●</span></td>
    <td><span style="font-size: 28px; color: {cycle|#00FFFF|#0088FF|#FF0000|#FF4400|#FF8800|#FFCC00|#FFFF00|#88FF00|#00FF00|#00FF88};">●</span></td>
  </tr>
  <tr>
    <td><span style="font-size: 28px; color: {cycle|#00FF88|#00FFFF|#0088FF|#FF0000|#FF4400|#FF8800|#FFCC00|#FFFF00|#88FF00|#00FF00};">●</span></td>
    <td><span style="font-size: 28px; color: {cycle|#00FF00|#00FF88|#00FFFF|#0088FF|#FF0000|#FF4400|#FF8800|#FFCC00|#FFFF00|#88FF00};">●</span></td>
    <td><span style="font-size: 28px; color: {cycle|#88FF00|#00FF00|#00FF88|#00FFFF|#0088FF|#FF0000|#FF4400|#FF8800|#FFCC00|#FFFF00};">●</span></td>
  </tr>
  <tr>
    <td><span style="font-size: 28px; color: {cycle|#FFFF00|#88FF00|#00FF00|#00FF88|#00FFFF|#0088FF|#FF0000|#FF4400|#FF8800|#FFCC00};">●</span></td>
    <td><span style="font-size: 28px; color: {cycle|#FFCC00|#FFFF00|#88FF00|#00FF00|#00FF88|#00FFFF|#0088FF|#FF0000|#FF4400|#FF8800};">●</span></td>
    <td><span style="font-size: 28px; color: {cycle|#FF8800|#FFCC00|#FFFF00|#88FF00|#00FF00|#00FF88|#00FFFF|#0088FF|#FF0000|#FF4400};">●</span></td>
  </tr>
</table>
```

Each cell cycles through the same rainbow colors but offset by one position, creating a diagonal
wave that flows from top-left to bottom-right. Adjust "Flip interval" in General settings to
control animation speed.
