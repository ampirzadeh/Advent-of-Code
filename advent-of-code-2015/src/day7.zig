const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

// Maps each wire name to its raw expression (e.g. "x AND y", "42", "NOT q").
const WireMap = std.StringHashMap([]const u8);
// Caches the already-computed signal value for each resolved wire name.
const Cache = std.StringHashMap(u16);

fn resolve(wires: *WireMap, cache: *Cache, name: []const u8) !u16 {
    if (std.mem.startsWith(u8, name, "NOT ")) {
        return ~try resolve(wires, cache, name["NOT ".len..]);
    }

    if (cache.get(name)) |val| return val;

    if (std.fmt.parseInt(u16, name, 10)) |val| return val else |_| {}

    const expr = wires.get(name).?;

    const val = if (std.mem.indexOf(u8, expr, " AND ")) |i|
        try resolve(wires, cache, expr[0..i]) & try resolve(wires, cache, expr[i + " AND ".len ..])
    else if (std.mem.indexOf(u8, expr, " OR ")) |i|
        try resolve(wires, cache, expr[0..i]) | try resolve(wires, cache, expr[i + " OR ".len ..])
    else if (std.mem.indexOf(u8, expr, " LSHIFT ")) |i|
        try resolve(wires, cache, expr[0..i]) << @intCast(try resolve(wires, cache, expr[i + " LSHIFT ".len ..]))
    else if (std.mem.indexOf(u8, expr, " RSHIFT ")) |i|
        try resolve(wires, cache, expr[0..i]) >> @intCast(try resolve(wires, cache, expr[i + " RSHIFT ".len ..]))
    else
        try resolve(wires, cache, expr);

    try cache.put(name, val);
    return val;
}

fn buildWires(sr: SolutionRunner, input: []const u8) !WireMap {
    var lines = std.mem.splitScalar(u8, input, '\n');

    var wires: WireMap = .init(sr.allocator);

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var parts = std.mem.splitSequence(u8, line, " -> ");

        const sourceValue = parts.next().?;
        const destRegister = parts.next().?;

        try wires.put(destRegister, sourceValue);
    }

    return wires;
}

pub fn part1(sr: SolutionRunner, input: []const u8) !u16 {
    var wires = try buildWires(sr, input);

    var cache: Cache = .init(sr.allocator);

    return try resolve(&wires, &cache, "a");
}

pub fn part2(sr: SolutionRunner, input: []const u8) !u16 {
    var wires = try buildWires(sr, input);

    var cache: Cache = .init(sr.allocator);

    const a_val = try resolve(&wires, &cache, "a");
    cache.clearRetainingCapacity();
    try cache.put("b", a_val);

    return try resolve(&wires, &cache, "a");
}
