const std = @import("std");
const SolutionRunner = @import("root.zig").SolutionRunner;

const Dimensions = struct {
    length: usize,
    width: usize,
    height: usize,
};

fn getDimensions(line: []const u8) !Dimensions {
    var dimensions_str = std.mem.splitScalar(u8, line, 'x');

    return .{
        .length = try std.fmt.parseInt(usize, dimensions_str.next().?, 10),
        .width = try std.fmt.parseInt(usize, dimensions_str.next().?, 10),
        .height = try std.fmt.parseInt(usize, dimensions_str.next().?, 10),
    };
}

pub fn part1(_: SolutionRunner, input: []const u8) !usize {
    var total: usize = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const dimensions = try getDimensions(line);

        const face1 = dimensions.length * dimensions.width;
        const face2 = dimensions.width * dimensions.height;
        const face3 = dimensions.height * dimensions.length;
        const smallest_face = @min(face1, face2, face3);
        total += 2 * (face1 + face2 + face3) + smallest_face;
    }
    return total;
}

pub fn part2(_: SolutionRunner, input: []const u8) !usize {
    var total: usize = 0;

    var lines = std.mem.splitScalar(u8, input, '\n');

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const dimensions = try getDimensions(line);

        const face1 = dimensions.length * dimensions.width;
        const face2 = dimensions.width * dimensions.height;
        const face3 = dimensions.height * dimensions.length;
        const smallest_face = @min(face1, face2, face3);

        // volume
        const bow_ribbon = dimensions.length * dimensions.width * dimensions.height;

        // smallest face's perimeter
        if (smallest_face == face1) {
            total += 2 * (dimensions.length + dimensions.width);
        } else if (smallest_face == face2) {
            total += 2 * (dimensions.width + dimensions.height);
        } else if (smallest_face == face3) {
            total += 2 * (dimensions.height + dimensions.length);
        } else {
            unreachable;
        }

        total += bow_ribbon;
    }

    return total;
}
