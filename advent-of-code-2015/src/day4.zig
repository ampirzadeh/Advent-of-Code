const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

const MD5Hash = [16]u8;

fn hash(input: []const u8, num: usize) !MD5Hash {
    var buf: [64]u8 = undefined;
    const s = try std.fmt.bufPrint(&buf, "{s}{d}", .{ input, num });

    var md5_hash: MD5Hash = undefined;
    std.crypto.hash.Md5.hash(s, &md5_hash, .{});

    return md5_hash;
}

pub fn part1(_: SolutionRunner, input: []const u8) !usize {
    const trimmedInput = std.mem.trimEnd(u8, input, &[_]u8{'\n'});

    for (0..std.math.maxInt(i32)) |i| {
        const md5_hash = try hash(trimmedInput, i);

        if (md5_hash[0] == 0x00 and md5_hash[1] == 0x00 and md5_hash[2] < 0x10) {
            return i;
        }
    }

    unreachable;
}

pub fn part2(_: SolutionRunner, input: []const u8) !usize {
    const trimmedInput = std.mem.trimEnd(u8, input, &[_]u8{'\n'});

    for (0..std.math.maxInt(i32)) |i| {
        const md5_hash = try hash(trimmedInput, i);

        if (md5_hash[0] == 0x00 and md5_hash[1] == 0x00 and md5_hash[2] == 0x00) {
            return i;
        }
    }

    unreachable;
}
