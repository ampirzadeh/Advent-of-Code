const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

fn runLengthEncoding(allocator: std.mem.Allocator, out: *std.ArrayList(u8), input: []const u8) !void {
    var currentChar: u8 = input[0];
    var count: u8 = 1;

    // skip first write of undefined char (1..)
    // do one extra iteration to dump the last run (len + 1)
    for (1..input.len + 1) |i| {
        const char = if (i < input.len) input[i] else 0;

        if (char == currentChar) {
            count += 1;
        } else {
            var buf: [16]u8 = undefined;
            const s = try std.fmt.bufPrint(&buf, "{d}{c}", .{ count, currentChar });
            try out.appendSlice(allocator, s);

            currentChar = char;
            count = 1;
        }
    }
}

fn getLength(sr: SolutionRunner, input: []const u8, iterations: u8) !usize {
    var current: std.ArrayList(u8) = .empty;
    defer current.deinit(sr.allocator);
    try current.appendSlice(sr.allocator, std.mem.trim(u8, input, " \t\n\r"));

    var next: std.ArrayList(u8) = .empty;
    defer next.deinit(sr.allocator);

    for (0..iterations) |_| {
        next.clearRetainingCapacity();
        try runLengthEncoding(sr.allocator, &next, current.items);

        std.mem.swap(std.ArrayList(u8), &current, &next);
    }

    return current.items.len;
}

pub fn part1(sr: SolutionRunner, input: []const u8) !usize {
    return try getLength(sr, input, 40);
}

pub fn part2(sr: SolutionRunner, input: []const u8) !usize {
    return try getLength(sr, input, 50);
}
