/*
	Copyright (c) 2019, DUNEX Contributors
	Use, modification and distribution are subject to the
	Boost Software License, Version 1.0.  (See accompanying file
	COPYING or copy at http://www.boost.org/LICENSE_1_0.txt)

	seq: output a sequence of numbers
	Author(s): chaomodus

	Bugs:
		Does not support full character escapes, just letter ones and \0.
 */

import common.escapes;

import std.array;
import std.algorithm;
import std.conv;
import std.getopt;
import std.format;
import std.stdio;

int main(string[] args) {
	string fmt = "%g";
	string specfmt;
	string separator = "\n";
	string terminal = "";
	bool width;

	auto helpInformation = getopt(args, std.getopt.config.passThrough,
		"f|format", "Specify a printf format", &specfmt,
		"s|separator", "Specify the separator to place between each number.", &separator,
		"t|terminal", "Specify the terminating character to print.", &terminal,
		"w|width", "Pad numbers to maximum width.", &width
	);

	if (helpInformation.helpWanted || args.length == 1) {
		defaultGetoptPrinter(
			"Output a sequence of numbers.\nSpecify [FIRST [INCR]] LAST, FIRST defaults to 0, INCR defaults to 1",
			helpInformation.options
		);
		return 1;
	}

	args.popFront();

	real first = 0;
	real incr = 1;
	real last;

	last = to!real(args[$ - 1]);

	if (args.length > 1) {
		if (args.length > 2) {
			incr = to!real(args[$ - 2]);
		}
		first = to!real(args[0]);
	}

	if (first > last) {
		if (incr > 0)
			incr = incr * -1;
	}

	ulong maxwidth;
	if (specfmt.length) {
		fmt = specfmt;
	} else {
		maxwidth = format(fmt, max(first, last)).length;
		if (width) {
			fmt = format("%%0%dg", maxwidth);
		}
	}

	separator = decodeEscapes(separator);
	if (terminal.length == 0)
		terminal = separator;
	else
		terminal = decodeEscapes(terminal);

	real seq;
	for (seq = first; (incr < 0) ? (seq + incr >= last) : (seq + incr <= last); seq += incr) {
		stdout.write(format(fmt, seq));
		stdout.write(separator);
	}
	stdout.write(format(fmt, seq + incr));
	stdout.write(terminal);

	return 0;
}
