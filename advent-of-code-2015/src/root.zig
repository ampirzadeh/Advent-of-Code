const std = @import("std");

pub const helpText =
    \\Usage: advent_of_code_2015 <day>
    \\
    \\Place your puzzle inputs in the inputs/ directory and name them as day<number>.txt
    \\
    \\Commands:
    \\ <day>: Run the solutions for the given day (provide as a standalone number)
    \\ help: Show this help message
    \\
    \\Options:
    \\  -h, --help    Show this help message
    \\
    \\Examples:
    \\  advent_of_code_2015 1
    \\  advent_of_code_2015 -h
    \\  advent_of_code_2015 --help
;

pub const SolutionRunner = struct {
    allocator: std.mem.Allocator,
    io: std.Io,

    pub fn run(
        self: @This(),
        comptime sol: type,
        day: u8,
        input: []const u8,
    ) !void {
        var stdout_file_writer: std.Io.File.Writer = .init(.stdout(), self.io, &.{});
        const stdout = &stdout_file_writer.interface;

        const p1 = try sol.part1(self, input);
        const p2 = try sol.part2(self, input);
        try stdout.print("Solution for day {}:\nPart 1: {}\nPart 2: {}\n", .{ day, p1, p2 });
    }
};
