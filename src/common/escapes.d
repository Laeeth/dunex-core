/*
	Copyright (c) 2019, DUNEX Contributors
	Use, modification and distribution are subject to the
	Boost Software License, Version 1.0.  (See accompanying file
	COPYING or copy at http://www.boost.org/LICENSE_1_0.txt)

	Author(s): chaomodus
	2019-11-29T17:43:11

	This implements decoding common character escapes.

	BUGS:
	* needs to support numeric character specifiers.
*/

module escapes;

import std.algorithm;
import std.array;
import std.string;

/***********************************
 * decode escaped character in the input string
 *
 * Supported escapes:
 * \t \0 \a \b \f \n \r \b \\
 * All other characters lead with a backslash are returned literally.
 *
 * Params:
 *        string inp = A string to decode the escapes from
 *
 * Returns:
 *        string = newly allocated string which is a copy of input string with escapes decoded.
 *
 */
@safe pure string decodeEscapes(const string input) {
	string ret;
	string inp = input;
	char ch;
	while (inp.length) {
		ch = inp[0];
		inp.popFront;
		if (ch == '\\') {
			ch = inp[0];
			inp.popFront;
			switch (ch) {
			case 't':
				ret ~= "\t";
				break;
			case '0':
				ret ~= "\0";
				break;
			case 'a':
				ret ~= "\a";
				break;
			case 'b':
				ret ~= "\b";
				break;
			case 'f':
				ret ~= "\f";
				break;
			case 'n':
				ret ~= "\n";
				break;
			case 'r':
				ret ~= "\r";
				break;
			case 'v':
				ret ~= "\v";
				break;
			default:
				ret ~= ch;
			}
		} else {
			ret ~= ch;
		}
	}
	return ret;
}

unittest {
  import escapes;

  assert(decodeEscapes(cast(string)r"\n\\\t\0\a\b\f\n\r\v\%") == "\n\\\t\0\a\b\f\n\r\v%");
}
