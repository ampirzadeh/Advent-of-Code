const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

pub fn part1(_: SolutionRunner, input: []const u8) !usize {
    var lines = std.mem.splitScalar(u8, input, '\n');

    var niceStringCount: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var vowelCount: usize = 0;
        var containsDouble: bool = false;
        var containsInvalid: bool = false;

        for (0..line.len) |i| {
            const char = line[i];

            if (char == 'a' or char == 'e' or char == 'i' or char == 'o' or char == 'u') {
                vowelCount += 1;
            }

            if (i < line.len - 1) {
                const nextChar = line[i + 1];

                if (char == nextChar) {
                    containsDouble = true;
                }

                if ((char == 'a' and nextChar == 'b') or
                    (char == 'c' and nextChar == 'd') or
                    (char == 'p' and nextChar == 'q') or
                    (char == 'x' and nextChar == 'y'))
                {
                    containsInvalid = true;
                    break;
                }
            }
        }

        if (vowelCount >= 3 and containsDouble and !containsInvalid) {
            niceStringCount += 1;
        }
    }

    return niceStringCount;
}

pub fn part2(_: SolutionRunner, input: []const u8) !usize {
    _ = input;
    return 0;
}
