const std = @import("std");

pub const Vector2 = struct {
    x: i32,
    y: i32,
};

/// A graph data structure that stores nodes and edges with weights using adjacency lists.
/// It is a design choice to use one allocator for all memory allocations for simplicity.
pub fn Graph(comptime TNode: type, comptime TWeight: type) type {
    comptime {
        if (TNode != []const u8) {
            @compileError("Graph only supports []const u8 node keys, got " ++ @typeName(TNode));
        }
    }
    return struct {
        const Self = @This();

        const TEdge = struct {
            to: usize,
            weight: TWeight,
        };

        allocator: std.mem.Allocator,
        /// Unmanaged because otherwise the allocator would need to be stored twice (in the HashMap itself as well).
        node_index: std.StringHashMapUnmanaged(usize),
        adjacency_list: std.ArrayList(std.ArrayList(TEdge)),

        pub fn init(allocator: std.mem.Allocator) !Self {
            return .{
                .allocator = allocator,
                .node_index = std.StringHashMapUnmanaged(usize).empty,
                .adjacency_list = std.ArrayList(std.ArrayList(TEdge)).empty,
            };
        }

        pub fn deinit(self: *Self) void {
            self.node_index.deinit(self.allocator);

            for (self.adjacency_list.items) |*list| {
                list.deinit(self.allocator);
            }
            self.adjacency_list.deinit(self.allocator);
        }

        pub fn getOrAddNode(self: *Self, node: TNode) !usize {
            const gop = try self.node_index.getOrPut(self.allocator, node);
            if (!gop.found_existing) {
                gop.value_ptr.* = self.adjacency_list.items.len;
                try self.adjacency_list.append(self.allocator, std.ArrayList(TEdge).empty);
            }
            return gop.value_ptr.*;
        }

        pub fn upsertEdge(self: *Self, from: TNode, to: TNode, weight: TWeight) !void {
            const from_index = try self.getOrAddNode(from);
            const to_index = try self.getOrAddNode(to);

            const list = &self.adjacency_list.items[from_index];
            for (list.items) |*edge| {
                if (edge.to == to_index) {
                    edge.weight = weight;
                    return;
                }
            }
            try list.append(self.allocator, .{ .to = to_index, .weight = weight });
        }
    };
}
