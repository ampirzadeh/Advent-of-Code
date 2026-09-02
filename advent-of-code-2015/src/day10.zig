/// For information about how this actually works
/// take a look at https://en.wikipedia.org/wiki/Look-and-say_sequence#Cosmological_decay
const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

const DecayInfo = struct {
    const Self = @This();

    sequence: []const u8,
    decaysInto: [6]?u8,
};

const atomDecayTable: [92]DecayInfo = .{
    .{ .sequence = "22", .decaysInto = .{ 0, null, null, null, null, null } },
    .{ .sequence = "13112221133211322112211213322112", .decaysInto = .{ 71, 90, 0, 19, 2, null } },
    .{ .sequence = "312211322212221121123222112", .decaysInto = .{ 1, null, null, null, null, null } },
    .{ .sequence = "111312211312113221133211322112211213322112", .decaysInto = .{ 31, 19, 2, null, null, null } },
    .{ .sequence = "1321132122211322212221121123222112", .decaysInto = .{ 3, null, null, null, null, null } },
    .{ .sequence = "3113112211322112211213322112", .decaysInto = .{ 4, null, null, null, null, null } },
    .{ .sequence = "111312212221121123222112", .decaysInto = .{ 5, null, null, null, null, null } },
    .{ .sequence = "132112211213322112", .decaysInto = .{ 6, null, null, null, null, null } },
    .{ .sequence = "31121123222112", .decaysInto = .{ 7, null, null, null, null, null } },
    .{ .sequence = "111213322112", .decaysInto = .{ 8, null, null, null, null, null } },
    .{ .sequence = "123222112", .decaysInto = .{ 9, null, null, null, null, null } },
    .{ .sequence = "3113322112", .decaysInto = .{ 60, 10, null, null, null, null } },
    .{ .sequence = "1113222112", .decaysInto = .{ 11, null, null, null, null, null } },
    .{ .sequence = "1322112", .decaysInto = .{ 12, null, null, null, null, null } },
    .{ .sequence = "311311222112", .decaysInto = .{ 66, 13, null, null, null, null } },
    .{ .sequence = "1113122112", .decaysInto = .{ 14, null, null, null, null, null } },
    .{ .sequence = "132112", .decaysInto = .{ 15, null, null, null, null, null } },
    .{ .sequence = "3112", .decaysInto = .{ 16, null, null, null, null, null } },
    .{ .sequence = "1112", .decaysInto = .{ 17, null, null, null, null, null } },
    .{ .sequence = "12", .decaysInto = .{ 18, null, null, null, null, null } },
    .{ .sequence = "3113112221133112", .decaysInto = .{ 66, 90, 0, 19, 26, null } },
    .{ .sequence = "11131221131112", .decaysInto = .{ 20, null, null, null, null, null } },
    .{ .sequence = "13211312", .decaysInto = .{ 21, null, null, null, null, null } },
    .{ .sequence = "31132", .decaysInto = .{ 22, null, null, null, null, null } },
    .{ .sequence = "111311222112", .decaysInto = .{ 23, 13, null, null, null, null } },
    .{ .sequence = "13122112", .decaysInto = .{ 24, null, null, null, null, null } },
    .{ .sequence = "32112", .decaysInto = .{ 25, null, null, null, null, null } },
    .{ .sequence = "11133112", .decaysInto = .{ 29, 26, null, null, null, null } },
    .{ .sequence = "131112", .decaysInto = .{ 27, null, null, null, null, null } },
    .{ .sequence = "312", .decaysInto = .{ 28, null, null, null, null, null } },
    .{ .sequence = "13221133122211332", .decaysInto = .{ 62, 19, 88, 0, 19, 29 } },
    .{ .sequence = "31131122211311122113222", .decaysInto = .{ 66, 30, null, null, null, null } },
    .{ .sequence = "11131221131211322113322112", .decaysInto = .{ 31, 10, null, null, null, null } },
    .{ .sequence = "13211321222113222112", .decaysInto = .{ 32, null, null, null, null, null } },
    .{ .sequence = "3113112211322112", .decaysInto = .{ 33, null, null, null, null, null } },
    .{ .sequence = "11131221222112", .decaysInto = .{ 34, null, null, null, null, null } },
    .{ .sequence = "1321122112", .decaysInto = .{ 35, null, null, null, null, null } },
    .{ .sequence = "3112112", .decaysInto = .{ 36, null, null, null, null, null } },
    .{ .sequence = "1112133", .decaysInto = .{ 37, 91, null, null, null, null } },
    .{ .sequence = "12322211331222113112211", .decaysInto = .{ 38, 0, 19, 42, null, null } },
    .{ .sequence = "1113122113322113111221131221", .decaysInto = .{ 67, 39, null, null, null, null } },
    .{ .sequence = "13211322211312113211", .decaysInto = .{ 40, null, null, null, null, null } },
    .{ .sequence = "311322113212221", .decaysInto = .{ 41, null, null, null, null, null } },
    .{ .sequence = "132211331222113112211", .decaysInto = .{ 62, 19, 42, null, null, null } },
    .{ .sequence = "311311222113111221131221", .decaysInto = .{ 66, 43, null, null, null, null } },
    .{ .sequence = "111312211312113211", .decaysInto = .{ 44, null, null, null, null, null } },
    .{ .sequence = "132113212221", .decaysInto = .{ 45, null, null, null, null, null } },
    .{ .sequence = "3113112211", .decaysInto = .{ 46, null, null, null, null, null } },
    .{ .sequence = "11131221", .decaysInto = .{ 47, null, null, null, null, null } },
    .{ .sequence = "13211", .decaysInto = .{ 48, null, null, null, null, null } },
    .{ .sequence = "3112221", .decaysInto = .{ 60, 49, null, null, null, null } },
    .{ .sequence = "1322113312211", .decaysInto = .{ 62, 19, 50, null, null, null } },
    .{ .sequence = "311311222113111221", .decaysInto = .{ 66, 51, null, null, null, null } },
    .{ .sequence = "11131221131211", .decaysInto = .{ 52, null, null, null, null, null } },
    .{ .sequence = "13211321", .decaysInto = .{ 53, null, null, null, null, null } },
    .{ .sequence = "311311", .decaysInto = .{ 54, null, null, null, null, null } },
    .{ .sequence = "11131", .decaysInto = .{ 55, null, null, null, null, null } },
    .{ .sequence = "1321133112", .decaysInto = .{ 56, 0, 19, 26, null, null } },
    .{ .sequence = "31131112", .decaysInto = .{ 57, null, null, null, null, null } },
    .{ .sequence = "111312", .decaysInto = .{ 58, null, null, null, null, null } },
    .{ .sequence = "132", .decaysInto = .{ 59, null, null, null, null, null } },
    .{ .sequence = "311332", .decaysInto = .{ 60, 19, 29, null, null, null } },
    .{ .sequence = "1113222", .decaysInto = .{ 61, null, null, null, null, null } },
    .{ .sequence = "13221133112", .decaysInto = .{ 62, 19, 26, null, null, null } },
    .{ .sequence = "3113112221131112", .decaysInto = .{ 66, 63, null, null, null, null } },
    .{ .sequence = "111312211312", .decaysInto = .{ 64, null, null, null, null, null } },
    .{ .sequence = "1321132", .decaysInto = .{ 65, null, null, null, null, null } },
    .{ .sequence = "311311222", .decaysInto = .{ 66, 60, null, null, null, null } },
    .{ .sequence = "11131221133112", .decaysInto = .{ 67, 19, 26, null, null, null } },
    .{ .sequence = "1321131112", .decaysInto = .{ 68, null, null, null, null, null } },
    .{ .sequence = "311312", .decaysInto = .{ 69, null, null, null, null, null } },
    .{ .sequence = "11132", .decaysInto = .{ 70, null, null, null, null, null } },
    .{ .sequence = "13112221133211322112211213322113", .decaysInto = .{ 71, 90, 0, 19, 73, null } },
    .{ .sequence = "312211322212221121123222113", .decaysInto = .{ 72, null, null, null, null, null } },
    .{ .sequence = "111312211312113221133211322112211213322113", .decaysInto = .{ 31, 19, 73, null, null, null } },
    .{ .sequence = "1321132122211322212221121123222113", .decaysInto = .{ 74, null, null, null, null, null } },
    .{ .sequence = "3113112211322112211213322113", .decaysInto = .{ 75, null, null, null, null, null } },
    .{ .sequence = "111312212221121123222113", .decaysInto = .{ 76, null, null, null, null, null } },
    .{ .sequence = "132112211213322113", .decaysInto = .{ 77, null, null, null, null, null } },
    .{ .sequence = "31121123222113", .decaysInto = .{ 78, null, null, null, null, null } },
    .{ .sequence = "111213322113", .decaysInto = .{ 79, null, null, null, null, null } },
    .{ .sequence = "123222113", .decaysInto = .{ 80, null, null, null, null, null } },
    .{ .sequence = "3113322113", .decaysInto = .{ 60, 81, null, null, null, null } },
    .{ .sequence = "1113222113", .decaysInto = .{ 82, null, null, null, null, null } },
    .{ .sequence = "1322113", .decaysInto = .{ 83, null, null, null, null, null } },
    .{ .sequence = "311311222113", .decaysInto = .{ 66, 84, null, null, null, null } },
    .{ .sequence = "1113122113", .decaysInto = .{ 85, null, null, null, null, null } },
    .{ .sequence = "132113", .decaysInto = .{ 86, null, null, null, null, null } },
    .{ .sequence = "3113", .decaysInto = .{ 87, null, null, null, null, null } },
    .{ .sequence = "1113", .decaysInto = .{ 88, null, null, null, null, null } },
    .{ .sequence = "13", .decaysInto = .{ 89, null, null, null, null, null } },
    .{ .sequence = "3", .decaysInto = .{ 90, null, null, null, null, null } },
};

inline fn findStartingElement(input: []const u8) !usize {
    for (0..atomDecayTable.len) |i| {
        if (std.mem.eql(u8, input, atomDecayTable[i].sequence)) {
            return i;
        }
    }

    @panic("I guessed that all inputs to this problem are single-element sequences, but your input is not one; so either I am wrong (reach out and let me know please :) or your input is invalid");
}

fn solve(sr: SolutionRunner, input: []const u8, iterationCount: usize) !usize {
    const start = try findStartingElement(std.mem.trim(u8, input, " \r\t\n"));

    var in: std.ArrayList(usize) = .empty;
    defer in.deinit(sr.allocator);
    try in.append(sr.allocator, start);

    var out: std.ArrayList(usize) = .empty;
    defer out.deinit(sr.allocator);

    for (0..iterationCount) |_| {
        for (in.items) |item| {
            const decaysInto = atomDecayTable[item];

            for (decaysInto.decaysInto) |decay| {
                if (decay) |d| try out.append(sr.allocator, d) else break;
            }
        }

        std.mem.swap(std.ArrayList(usize), &in, &out);
        out.clearRetainingCapacity();
    }

    var res: usize = 0;

    for (in.items) |item| {
        res += atomDecayTable[item].sequence.len;
    }

    return res;
}

pub fn part1(sr: SolutionRunner, input: []const u8) !usize {
    return solve(sr, input, 40);
}

pub fn part2(sr: SolutionRunner, input: []const u8) !usize {
    return solve(sr, input, 50);
}
