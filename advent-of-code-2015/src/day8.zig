const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

pub fn part1(_: SolutionRunner, input: []const u8) !usize {
    var lines = std.mem.splitScalar(u8, input, '\n');

    var stringLiteralLength: usize = 0;
    var escapedStringLength: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        stringLiteralLength += line.len;

        var i: usize = 0;
        while (i < line.len) {
            switch (line[i]) {
                '"' => {
                    i += 1;
                    continue;
                },
                '\\' => {
                    // an escape sequence always results in one character being added
                    escapedStringLength += 1;

                    // skip ahead
                    i += switch (line[i + 1]) {
                        '\\' => 2,
                        '"' => 2,
                        'x' => 4,
                        else => unreachable,
                    };
                },
                else => {
                    escapedStringLength += 1;
                    i += 1;
                },
            }
        }
    }

    return stringLiteralLength - escapedStringLength;
}

pub fn part2(_: SolutionRunner, input: []const u8) !u16 {
    _ = input;
    return 0;
}
