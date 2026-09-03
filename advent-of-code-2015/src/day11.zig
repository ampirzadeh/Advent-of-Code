/// For information about how this actually works
/// take a look at https://en.wikipedia.org/wiki/Look-and-say_sequence#Cosmological_decay
const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

fn incrementString(allocator: std.mem.Allocator, num: *std.ArrayList(u8)) !void {
    // add one
    var carry: u8 = 1;

    var i = num.items.len - 1;
    while (i < num.items.len) : (i -%= 1) {
        num.items[i] += carry;
        carry = (num.items[i] - 'a') / 26;
        num.items[i] = (num.items[i] - 'a') % 26 + 'a';
    }

    if (carry > 0) {
        try num.insert(allocator, 0, 'a');
    }
}

pub fn part1(sr: SolutionRunner, input: []const u8) !usize {
    var a: std.ArrayList(u8) = .fromOwnedSlice(input);
    defer a.deinit(sr.allocator);

    try a.append(sr.allocator, 'z');
    try a.append(sr.allocator, 'z');
    try a.append(sr.allocator, 'z');
    _ = try incrementString(sr.allocator, &a);

    for (a.items) |c| {
        std.debug.print("{c} ", .{c});
    }

    std.debug.print("\n", .{});

    return 0;
}

pub fn part2(sr: SolutionRunner, input: []const u8) !usize {
    _ = input;
    _ = sr;
    return 0;
}
