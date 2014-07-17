/*
 * jQuery prettyDate v1.1.3
 *
 * @author John Resig (ejohn.org)
 * @author Jörn Zaefferer
 * @author Timo Tijhof
 *
 * Based on http://ejohn.org/blog/javascript-pretty-date
 * Documentation: http://bassistance.de/jquery-plugins/jquery-plugin-prettydate/
 *
 * Copyright 2013 Jörn Zaefferer
 * Released under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 */

(function ($) {
	'use strict';

	var slice = Array.prototype.slice,
		rES5ts = /^(\d{4}|[+\-]\d{6})(?:-(\d{2})(?:-(\d{2}))?)?(?:T(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d{3}))?)?(?:(Z)|([+\-])(\d{2})(?::(\d{2}))?)?)?$/,
		// Indexes in a rES5ts match list that are required for Date.UTC,
		// Use in a loop to replace undefined with 0 (otherwise Date.UTC would give NaN)
		dateUrcReqIndx = [1, 4, 5, 6, 7, 10, 11];

	$.prettyDate = {

		/**
		 * Replace numerial placeholders ({0}, {1}, ..) with the value
		 * at that index in the array or variadic list of arugments.
		 * When called with only a source, a function is returned that calls itself
		 * again, that time with the arguments passed to apply the template.
		 *
		 * @param {string} source Text containing {#} placeholders where
		 *  '#' is a number referring to an index in `params`.
		 * @param {string|Array} [params...] List of replacement values or a
		 *  varadic argument list starting where this argument is the first one.
		 */
		template: function (source, params) {
			if (arguments.length === 1) {
				return function () {
					var args = slice.call(arguments);
					args.unshift(source);
					return $.prettyDate.template.apply(this, args);
				};
			}
			// Detect different call patterns:
			// * template(source, [1, 2, 3])
			// * template(source, 1, 2, 3)
			if (!$.isArray(params)) {
				params = slice.call(arguments, 1);
			}
			$.each(params, function (i, n) {
				source = source.replace(new RegExp('\\{' + i + '\\}', 'g'), n);
			});
			return source;
		},

		/**
		 * Offset from which the relative date will be generated.
		 * @return {Date}
		 */
		now: function () {
			return new Date();
		},

		/**
		 * Implementation of the ES5 Date.parse specification (ES5 §15.9.4.2,
		 * which is a subset of ISO 8601), see http://es5.github.com/#x15.9.1.15.

		 * Since Date.parse already existed in old browsers and there would be
		 * many forms to be tested for, don't use feature-detection but just
		 * implement it straight up.
		 *
		 * Based on https://github.com/csnover/js-iso8601
		 *
		 * @example
		 *  '2012'
		 *  '2012-01-07'
		 *  '2012-01-07T23:30:59Z'
		 *  '2012-01-07T23:30:59+01:00'
		 *  '2012-01-07T23:30:59.001+01:00'
		 * @param {string} timestamp
		 * @return {number} Unix epoch or NaN.
		 */
		parse: function (timestamp) {
			var i, k, minutesOffset,
				m = rES5ts.exec(timestamp);
			if (!m) {
				return NaN;
			}
			for (i = 0; (k = dateUrcReqIndx[i]); i += 1) {
				m[k] = +m[k] || 0;
			}
			// Undefined days and months are allowed
			m[2] = +m[2] || 1;
			m[3] = +m[3] || 1;

			if (m[8] !== 'Z' && m[9] !== undefined) {
				minutesOffset = m[10] * 60 + m[11];

				if (m[9] === '+') {
					minutesOffset = 0 - minutesOffset;
				}
			} else {
				minutesOffset = 0;
			}

			return Date.UTC(
				// Year
				m[1],
				// Month
				m[2] - 1,
				// Day
				m[3],
				// Hour
				m[4],
				// Minutes
				// Date.UTC allows values higher than 59 here,
				// it increments hours, days etc. if needed.
				m[5] + minutesOffset,
				// Seconds
				m[6],
				// Milliseconds
				m[7]
			);
		},

		/**
		 * Takes an ISO time and returns a string representing how
		 * long ago the date represents.
		 * @param {string} targetTs Timestamp in ISO 8601 format.
		 * @return {string}
		 */
		format: function (target) {
			var messages,
				targetTime = $.prettyDate.parse(target),
				nowTime = $.prettyDate.now().getTime(),
				diff = (nowTime - targetTime) / 1000,
				dayDiff = Math.floor(diff / 86400);

			if (isNaN(dayDiff) || dayDiff < 0) {
				return;
			}

			messages = $.prettyDate.messages;
			return dayDiff === 0 && (
					diff < 60 && messages.now ||
					diff < 120 && messages.minute ||
					diff < 3600 && messages.minutes(Math.floor(diff / 60)) ||
					diff < 7200 && messages.hour ||
					diff < 86400 && messages.hours(Math.floor(diff / 3600))) ||
					dayDiff === 1 && messages.yesterday ||
					dayDiff < 7 && messages.days(dayDiff) ||
					dayDiff < 8 && messages.week ||
					dayDiff < 14 && messages.days(dayDiff) ||
					dayDiff < 30 && messages.weeks(Math.ceil(dayDiff / 7)) ||
					dayDiff < 32 && messages.month ||
					dayDiff < 363 && messages.months(Math.ceil(dayDiff / 31)) ||
					dayDiff <= 380 && messages.year ||
					dayDiff > 380 && messages.years(Math.ceil(dayDiff / 365));
		}

	};

	$.prettyDate.messages = {
		now: 'just now',
		minute: '1 minute',
		minutes: $.prettyDate.template('{0} minutes'),
		hour: '1 hour',
		hours: $.prettyDate.template('{0} hours'),
		yesterday: 'Yesterday',
		days: $.prettyDate.template('{0} days'),
		week: '1 week',
		weeks: $.prettyDate.template('{0} weeks'),
		month: '1 month',
		months: $.prettyDate.template('{0} months'),
		year: '1 year',
		years: $.prettyDate.template('{0} years')
	};

	/**
	 * @context {jQuery}
	 * @param {Object} options
	 *  - {number|false} interval Time in milliseconds between updates,
	 *      or set to false to disable auto updating interval.
	 *  - {string} attribute Name of attribute where the timestamp should
	 *     be accessed from.
	 *  - {Function} value Overrides 'attribute', a custom function to get the
	 *     timestamp. 'this' context is set to the HTMLElement.
	 */
	$.fn.prettyDate = function (options) {
		options = $.extend({
			interval: 10000,
			attribute: 'title',
			value: function () {
				return $(this).attr(options.attribute);
			}
		}, options);
		var elements = this;
		function format() {
			elements.each(function () {
				var date = $.prettyDate.format(options.value.apply(this));
				if (date && $(this).text() !== date) {
					$(this).text(date);
				}
			});
		}
		format();
		if (options.interval) {
			setInterval(format, options.interval);
		}
		return this;
	};

}(jQuery));
