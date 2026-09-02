// Hamiltonian Path

const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;
const Graph = @import("lib.zig").Graph;

const MyGraph = Graph([]const u8, i32);

fn buildGraph(input: []const u8, allocator: std.mem.Allocator) !MyGraph {
    var lines = std.mem.splitScalar(u8, input, '\n');

    var myGraph = try MyGraph.init(allocator);

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var parts = std.mem.splitSequence(u8, line, " = ");
        const path = parts.next().?;
        const distance = parts.next().?;
        const parsed_distance = try std.fmt.parseInt(i32, distance, 10);

        var cities = std.mem.splitSequence(u8, path, " to ");
        const city1 = cities.next().?;
        const city2 = cities.next().?;

        _ = try myGraph.getOrAddNode(city1);
        _ = try myGraph.getOrAddNode(city2);

        _ = try myGraph.upsertEdge(city1, city2, parsed_distance);
        _ = try myGraph.upsertEdge(city2, city1, parsed_distance);
    }

    return myGraph;
}

inline fn idx(N: usize, mask: usize, v: usize) usize {
    return mask * N + v;
}

inline fn twoToThePowerOf(n: usize) usize {
    return @as(usize, 1) << @intCast(n);
}

/// dp[S][v] = minimum cost of the path that visits exactly the nodes in S, ending at v.
/// where dp is a 2D array of dimensions: (2^node_count)*node_count, but is represented as a flat array;
/// where S is a subset of the nodes, represented as a bitmask;
/// where v is the ending node (as an index into the node index)
fn buildDp(allocator: std.mem.Allocator, myGraph: *MyGraph, wanted: enum { max_route, min_route }) !i32 {
    const N: usize = myGraph.node_index.count();
    const state_count: usize = twoToThePowerOf(N);
    const capacity = state_count * N;
    const full_mask = state_count - 1;

    const dp = try allocator.alloc(i32, capacity);
    defer allocator.free(dp);

    // ATTENTION:
    @memset(dp, if (wanted == .max_route) std.math.minInt(i32) else std.math.maxInt(i32));

    // Base case: a path visiting only node v, ending at v, costs 0.
    for (0..N) |v| {
        dp[idx(N, twoToThePowerOf(v), v)] = 0;
    }

    // Held-Karp transitions: build up all subset paths.
    for (1..state_count) |mask| {
        for (0..N) |v| {
            // Skip if v is not in the current mask.
            if ((mask & twoToThePowerOf(v)) == 0) continue;

            // For each neighbor u of v that is in the current mask, update the cost of the path ending at u.
            const cur = dp[idx(N, mask, v)];
            if (cur == std.math.minInt(i32)) continue;

            for (myGraph.adjacency_list.items[v].items) |edge| {
                const u = edge.to;
                if ((mask & twoToThePowerOf(u)) != 0) continue;
                const next_mask = mask | twoToThePowerOf(u);
                const target = idx(N, next_mask, u);
                const candidate = cur + edge.weight;

                // ATTENTION:
                if (wanted == .max_route and candidate > dp[target]) {
                    dp[target] = candidate;
                } else if (wanted == .min_route and candidate < dp[target]) {
                    dp[target] = candidate;
                }
            }
        }
    }

    // ATTENTION:
    var result: i32 = if (wanted == .max_route) std.math.minInt(i32) else std.math.maxInt(i32);
    for (0..N) |v| {
        result = if (wanted == .max_route) @max(result, dp[idx(N, full_mask, v)]) else @min(result, dp[idx(N, full_mask, v)]);
    }

    return result;
}

pub fn part1(sr: SolutionRunner, input: []const u8) !i32 {
    var myGraph = try buildGraph(input, sr.allocator);
    defer myGraph.deinit();

    const result = try buildDp(sr.allocator, &myGraph, .min_route);

    return result;
}

pub fn part2(sr: SolutionRunner, input: []const u8) !i32 {
    var myGraph = try buildGraph(input, sr.allocator);
    defer myGraph.deinit();

    const result = try buildDp(sr.allocator, &myGraph, .max_route);

    return result;
}
