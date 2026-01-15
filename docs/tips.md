![HTML Clock for Plasma](../img/banner.png)

---

## Table of Contents ##

* [Configuration](configuration.md)
* [Placeholders](placeholders.md)
* [Tips and tricks](tips.md)
  * [Blinking](#blinking)
* [Installation and upgrading](installation.md)

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
minutes. Unfortunately we cannot use CSS animators here as these are not supported by QT
implementation. But we can do some smart tricks with text colors, as fortunately for us, QT supports
CSS colors as well as its alpha channel (aka transparency). So to make thing blink, we will be
simply cycling between fully transparent and fully opaque every second. To achieve that effect, you
need to use special placeholder called `{cycle|XX|YY}`, which is simply replaced by `XX` on every
even second, and by `YY` on every odd second.

#### Examples ####

Knowing that CSS color format is `#AARRGGBB` where `AA` is alpha channel value from `00` being fully
transparent to `FF` (255 in decimal) being fully opaque, we can do this:

```html
<span style="color: #{cycle|00|FF}ffffff;">BLINK!</span>
```

![Cycling alpha channel value](img/flip-01.gif)

But if you want, you can also blink by toggling whole colors:

```html
<span style="color: {cycle|#ff0000|#00ff00};">BLINK!</span>
<span style="color: {cycle|red|green};">BLINK!</span>
```

or by
using [QT supported SVG color names](https://doc.qt.io/qt-6/qml-color.html#svg-color-reference):

```html
<span style="color: {cycle|red|green};">BLINK!</span>
```

You can use `{cycle}` as many times as you want, so you can easily achieve this:

```html
<span style="color: {cycle|#ff0000|green};">{cycle|THIS|BLINKS}!</span>
```

![Cycle example 02](img/flip-02.gif)

As already mentioned, you can also cycle other placeholders:

```html
{cycle|{MMM} {dd}, {yyyy}|Today is {DDD}}
```

![Cycle example 03](img/flip-03.gif)
