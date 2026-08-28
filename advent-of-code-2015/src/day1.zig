const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

const Bracket = enum { Open, Close };

pub fn part1(_: SolutionRunner, input: []const u8) !i32 {
    var currentFloor: i32 = 0;

    for (input) |char| {
        if (char == '(') {
            currentFloor += 1;
        } else if (char == ')') {
            currentFloor -= 1;
        }
    }

    return currentFloor;
}

pub fn part2(_: SolutionRunner, input: []const u8) !usize {
    var currentFloor: i32 = 0;

    for (input, 0..input.len) |char, i| {
        if (char == '(') {
            currentFloor += 1;
        } else if (char == ')') {
            currentFloor -= 1;
        }

        if (currentFloor == -1) {
            return i + 1;
        }
    }

    @panic("Did not enter basement");
}
