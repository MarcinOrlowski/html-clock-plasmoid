![HTML CLock for Plasma](img/banner.png)


# Changelog

---

## dev (TBD)

- Added widget logo.
- Reorganized documentation into separate files.
- Added live clock layout preview in configuration dialog.
- Changed widget icon from analog to digital clock [#95].
- Added configurable flip interval for {flip} placeholder [#69].
- Added option to launch app on widget click instead of calendar [#73].
- Fixed timezone offset calculation for positive offsets [#1].
- Fixed global timezone offset not updating date placeholders correctly [#82].
- Added `|` as placeholder separator for modifiers (e.g. `{hh|U}`) and `{flip}` (allows `:` in values).
- Added per-placeholder timezone offset support using `|` separator (e.g. `{hh|+09:00}`) [#1].
- Added translation/i18n support for settings UI with 14 languages [#85].
- Documented `{wy}` week of year placeholder [#71].
- Added `{cycle}` placeholder for multi-value cycling [#127].

## v2.0.0 (2026-01-13)

- Ported widget to KDE Plasma 6.
- Removed custom version checking (KDE Discover handles updates).

## v1.6.4 (2023-02-20)

- Fixed incorrect handling of multiple `{flip}` entries placed in the same line in template
  markup [#57].

## v1.6.3 (2022-09-02)

- Fixed layout config control buttons being rendered in unusable form [#35].

## v1.6.2 (2021-12-12)

- Fixed broken calendar view.

## v1.6.1 (2021-12-07)

- Fixed widget tooltip not honoring TimeZone offset when enabled.

## v1.6.0 (2021-12-06)

- Added option to specify time zone offset (in `[+/-]HH:MM` format) to support "world clock"
  application.
- Added option to force widget container fill its parent container in 100% available.

## v1.5.0 (2021-03-25)

- Added support for Plasma 5.19's transparent background feature.

## v1.4.0 (2021-03-24)

- Added option to make widget background transparent.

## v1.3.1 (2021-03-23)

- Dropped use of "backtick" JS syntax due to problems on Debian 10's Plasma
  version. Reported by @Kolychy [#28]

## v1.3.0 (2021-01-29)

- Added support for using custom font [#23].
- Added color and font helpers to layout editor.
- Removed layout editor's custom context menu. CTRL-C/CTRL-V/CTRL-X works.
- Removed :Default base font pixel size" as now is taken from font used.

## v1.2.1 (2021-01-27)

- Added "Date & Time grid" layout
- Added "Date & Time w/dayname grid" layout
- Fixed tooltip content not being properly updated (Reported by @noir-Z [#20])

## v1.2.0 (2021-01-25)

- New placeholder `{flip}` that helps adding some nice tricks with your layouts.
- Replaced `Timer` with "time" DataSource.
- All built-in layouts use 1px base font size to make layouts more compact.
- Fixed `{k}` to return correct PM hours. PR by @NICHILAS85 [#14]
- Fixed `{k}` and `{kk}` to return `12` instead of `0`. PR by @NICHILAS85 [#15]

## v1.1.2 (2021-01-24)

- Fixed widget width being truncated in some cases. Reported by @NICHOLAS85 [#11]

## v1.1.1 (2021-01-22)

- Layout editor now warns if user theme is being edited but not enabled.
- Updated documentation.
- Added new layout with superscripted seconds.
- Fixed widget getting too wide on horizontal Panel.

## v1.1.0 (2021-01-21)

- Added support for `{s}` and `{ss}` placeholders.
- Rearranged configuration panes.

## v1.0.0 (2021-01-20)

- Initial public release.
