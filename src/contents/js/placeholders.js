/**
 * HTML Clock Plasmoid
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2026 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

// https://doc.qt.io/qt-6/qtqml-javascript-resources.html
.pragma library

/*
** Stateful placeholders ({flip}, {cycle}, {random}) shared by the widget and
** by all configuration dialog previews. The cycling counters live in the QML
** components (they need Timers), so they are passed in as arguments here.
**
** Scanning is brace depth aware, so values may contain other placeholders,
** including their own modifiers and timezone offsets, i.e.
** {cycle|{MMM} {dd}|Today is {DDD}} or {cycle|{hh|+09:00}|{hh|-05:00}}.
*/

/*
** Returns index just past the "}" closing the "{" at given position, or -1
** when braces never balance out (malformed markup).
**
** Arguments:
**   text: string to scan
**  start: index of the opening "{"
*/
function findBlockEnd(text, start) {
	var depth = 0
	for (var i = start; i < text.length; i++) {
		var ch = text.charAt(i)
		if (ch === '{') {
			depth++
		} else if (ch === '}') {
			depth--
			if (depth === 0) return i + 1
		}
	}

	return -1
}

/*
** Splits string on separators found at brace depth 0 only, so separators
** belonging to nested placeholders are left alone.
**
** Arguments:
**       body: string to split
**  separator: single separator character
**      limit: (optional) max number of parts. Remainder is kept unsplit
**             in the last part.
*/
function splitTopLevel(body, separator, limit) {
	var parts = []
	var current = ''
	var depth = 0
	for (var i = 0; i < body.length; i++) {
		var ch = body.charAt(i)
		if (ch === '{') {
			depth++
		} else if (ch === '}') {
			depth--
		}

		if (ch === separator && depth === 0 && (limit === undefined || parts.length < limit - 1)) {
			parts.push(current)
			current = ''
		} else {
			current += ch
		}
	}
	parts.push(current)

	return parts
}

/*
** Replaces every "{<name><separator>...}" block with the value returned by
** the pick() callback. Contents of the block are never rescanned, so a value
** that happens to look like another placeholder is left for the next stage
** of the pipeline to handle.
**
** Arguments:
**        text: template to process
**        name: placeholder name, lowercase (i.e. 'cycle')
**   separator: single separator character
**       limit: (optional) max number of values, see splitTopLevel()
**        pick: function(values, occurrence) returning the replacement string
*/
function expand(text, name, separator, limit, pick) {
	var prefix = '{' + name + separator
	// Placeholder names are matched case insensitively.
	var haystack = text.toLowerCase()

	var result = ''
	var pos = 0
	var occurrence = 0
	while (true) {
		var start = haystack.indexOf(prefix, pos)
		if (start === -1) break

		var end = findBlockEnd(text, start)
		if (end === -1) break

		var body = text.substring(start + prefix.length, end - 1)
		result += text.substring(pos, start) + pick(splitTopLevel(body, separator, limit), occurrence)
		occurrence++
		pos = end
	}

	return result + text.substring(pos)
}

/*
** Processes deprecated {flip|A|B} placeholders (and the legacy {flip:A:B}
** form). Flip is just {cycle} with two values.
**
** Arguments:
**        text: template to process
**  cycleIndex: current cycle counter
*/
function expandFlip(text, cycleIndex) {
	var pick = function(values) {
		return values[cycleIndex % values.length]
	}

	text = expand(text, 'flip', '|', 2, pick)
	text = expand(text, 'flip', ':', 2, pick)

	return text
}

/*
** Processes {cycle|A|B|C|...} placeholders.
**
** Arguments:
**        text: template to process
**  cycleIndex: current cycle counter
*/
function expandCycle(text, cycleIndex) {
	return expand(text, 'cycle', '|', undefined, function(values) {
		return values[cycleIndex % values.length]
	})
}

/*
** Returns the number of ticks after which all {cycle} and {flip} placeholders
** in the template show their first values again, that is the least common
** multiple of their value counts. Templates with no cycling placeholders give
** 1. Callers use it to enumerate every variant a template can render, i.e. to
** measure the widest one [#166].
**
** Scanning is done on the raw template, so values hidden in the branch of a
** {flip} that is not picked right now are counted too. That only makes the
** period longer than strictly needed, never shorter.
**
** Arguments:
**  text: template to scan
**   cap: (optional) upper limit of the returned period, default 24. Keeps
**        exotic templates from making the caller enumerate hundreds of
**        variants.
*/
function cyclePeriod(text, cap) {
	if (cap === undefined) cap = 24

	var period = 1
	var track = function(values) {
		var count = values.length
		if (count > 1 && period < cap) {
			var a = period
			var b = count
			while (b !== 0) {
				var t = a % b
				a = b
				b = t
			}
			period = Math.min(period * count / a, cap)
		}

		// Only the value counts matter here, the expanded text is discarded.
		return ''
	}

	expand(text, 'cycle', '|', undefined, track)
	expand(text, 'flip', '|', 2, track)
	expand(text, 'flip', ':', 2, track)

	return period
}

/*
** Processes {random|A|B|C|...} placeholders. Picks are kept per occurrence
** position, so each placeholder holds its value until randomIndex changes,
** and never repeats the value picked in the previous round.
**
** Arguments:
**         text: template to process
**  randomIndex: current random counter
**        state: caller owned object, created as ({picks: {}, lastIndex: -1})
*/
function expandRandom(text, randomIndex, state) {
	if (randomIndex !== state.lastIndex) {
		state.lastIndex = randomIndex
		state.picks[randomIndex] = {}
		// Drop rounds no longer needed to prevent memory leak.
		for (var key in state.picks) {
			if (parseInt(key) < randomIndex - 1) delete state.picks[key]
		}
	}

	var current = state.picks[randomIndex] || {}
	var previous = state.picks[randomIndex - 1] || {}
	state.picks[randomIndex] = current

	return expand(text, 'random', '|', undefined, function(values, occurrence) {
		var posKey = 'p' + occurrence
		var picked = current[posKey]
		if (picked === undefined) {
			var last = previous[posKey]
			if (values.length <= 1) {
				picked = 0
			} else {
				// Pick random index, but different from the previous one.
				do {
					picked = Math.floor(Math.random() * values.length)
				} while (picked === last)
			}
			current[posKey] = picked
		}

		return values[picked]
	})
}
