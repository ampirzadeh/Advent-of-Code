const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;
const Vector2 = @import("lib.zig").Vector2;

const startsWith = std.mem.startsWith;
const splitScalar = std.mem.splitScalar;
const splitSequence = std.mem.splitSequence;

const Action = enum {
    turn_on,
    turn_off,
    toggle,
};
const Instruction = struct {
    action: Action,
    p1: Vector2,
    p2: Vector2,
};

fn parseCoords(s: []const u8) !Vector2 {
    var coords = splitScalar(u8, s, ',');

    return .{
        .x = try std.fmt.parseInt(i32, coords.next().?, 10),
        .y = try std.fmt.parseInt(i32, coords.next().?, 10),
    };
}

fn parseInstruction(line: []const u8) !Instruction {
    var action: Action = undefined;
    var rest: []const u8 = undefined;

    if (startsWith(u8, line, "turn on ")) {
        action = .turn_on;
        rest = line["turn on ".len..];
    } else if (startsWith(u8, line, "turn off ")) {
        action = .turn_off;
        rest = line["turn off ".len..];
    } else if (startsWith(u8, line, "toggle ")) {
        action = .toggle;
        rest = line["toggle ".len..];
    } else unreachable;

    var coordsStrings = splitSequence(u8, rest, " through ");
    const p1Str = coordsStrings.next().?;
    const p2Str = coordsStrings.next().?;

    const p1 = try parseCoords(p1Str);
    const p2 = try parseCoords(p2Str);

    return .{
        .p1 = p1,
        .p2 = p2,
        .action = action,
    };
}

pub fn part1(_: SolutionRunner, input: []const u8) !i32 {
    var lines = splitScalar(u8, input, '\n');

    const Grid = [1000][1000]bool;
    var grid: Grid = std.mem.zeroes(Grid);

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const instruction = try parseInstruction(line);

        const p1y: usize = @intCast(instruction.p1.y);
        const p1x: usize = @intCast(instruction.p1.x);
        const p2y: usize = @intCast(instruction.p2.y);
        const p2x: usize = @intCast(instruction.p2.x);

        for (p1y..p2y + 1) |y| {
            for (p1x..p2x + 1) |x| {
                grid[y][x] = switch (instruction.action) {
                    .turn_on => true,
                    .turn_off => false,
                    .toggle => !grid[y][x],
                };
            }
        }
    }

    var count: i32 = 0;
    for (grid) |row| {
        for (row) |cell| {
            if (cell) count += 1;
        }
    }

    return count;
}

pub fn part2(_: SolutionRunner, input: []const u8) !i32 {
    var lines = splitScalar(u8, input, '\n');

    const Grid = [1000][1000]i32;
    var grid: Grid = std.mem.zeroes(Grid);

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const instruction = try parseInstruction(line);

        const p1y: usize = @intCast(instruction.p1.y);
        const p1x: usize = @intCast(instruction.p1.x);
        const p2y: usize = @intCast(instruction.p2.y);
        const p2x: usize = @intCast(instruction.p2.x);

        for (p1y..p2y + 1) |y| {
            for (p1x..p2x + 1) |x| {
                grid[y][x] = switch (instruction.action) {
                    .turn_on => grid[y][x] + 1,
                    .turn_off => @max(grid[y][x] - 1, 0),
                    .toggle => grid[y][x] + 2,
                };
            }
        }
    }

    var total: i32 = 0;
    for (grid) |row| {
        for (row) |cell| {
            total += cell;
        }
    }

    return total;
}
