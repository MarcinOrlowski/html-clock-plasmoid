HTML Clock for KDE
==================

Plasma/KDE clock widget, stylable with QT provided subset of HTML


![Widget in action](img/widget.png)


For list of supported HTML tags [click here](https://doc.qt.io/qt-5/richtext-html-subset.html).


Placeholders
============

 Your formatting string can contain anything you like, however certain sequences are considered
 placeholders, and will be replaced by corresponding values. Non-placeholders are returned
 unprocessed

| Placeholder | Description |
|-------------|-------------|
| {yy} 		| long year (i.e. "2009") |
| {y} 		| short year (i.e. "09") |
| {MMM}	    | long month name (i.e. "January") |
| {MM}		| abbreviated month name (i.e. "Jan") |
| {M}		| first letter of month name (i.e. "J") |
| {mm}		| zero prefixed 2 digit month number ("02" for Feb, "12" for Dec) |
| {m}		| month number as is ("2" for Feb, "12" for Dec) |
| {DDD}	    | full day name (i.e. ""Saturday", "Sunday", "Monday") |
| {DD}		| abbreviated day name ("Sat", "Sun", "Mon") |
| {D}		| one letter day name ("S", "S", "M") |
| {dd}		| zero prefixed 2 digit day number ("01", "27") |
| {d}		| day number as is ("1", "27") |
| {hh}		| current hour, zero prefixed, 24hrs clock (i.e. "01", "16") |
| {h}		| current hour, 24hrs clock (i.e. "1", "16") |
| {kk}		| current hour, zero prefixed, 12hrs clock (i.e. "01", "11") |
| {k}		| current hour, 12hrs clock (i.e. "1", "11") |
| {ii}		| current minute, zero prefixed (i.e. "01", "35") |
| {i}		| current minute (i.e. "1", "35") |
| {ss}		| current seconde, zero prefixed (i.e. "01", "35") |
| {s}		| current second (i.e. "1", "35") |
| {AA}		| upper-cased AM/PM marker (i.e. "AM") |
| {A}		| upper-cased abbreviated AM/PM marker. "A" for "AM", "P" for "PM" |
| {aa}		| lower-cased am/pm marker (i.e. "am") |
| {a}		| lower-cased abbreviated AM/PM marker. "a" for "am", "p" for "pm" |
| {Aa}		| AM/PM marker with first letter uppercased (i.e. "Am"/"Pm") |
| {t}		| Timezone name (i.e. "UTC")
| {ldl}		| Locale based date long format |
| {lds}		| Locale based date short format |
| {ltl}		| Locale based time long format |
| {lts}		| Locale based time short format |
| {ldtl}	| Locale based date and time long format |
| {ldts}	| Locale based date and time short format |

