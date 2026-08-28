const std = @import("std");
const Io = std.Io;

const root = @import("root.zig");
const helpText = root.helpText;
const SolutionRunner = root.SolutionRunner;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.arena.allocator();

    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &.{});
    const stdout = &stdout_file_writer.interface;

    var stderr_file_writer: Io.File.Writer = .init(.stderr(), io, &.{});
    const stderr = &stderr_file_writer.interface;

    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 2 or args.len > 2) {
        try stdout.print(helpText, .{});
        return;
    }

    const firstArg = args[1];

    if (std.mem.containsAtLeast(u8, firstArg, 1, "help")) {
        try stdout.print(helpText, .{});
        return;
    }

    const day = std.fmt.parseInt(u8, firstArg, 10) catch {
        try stderr.print("Invalid <day> provided. See help for usage.", .{});
        return;
    };

    const runner = SolutionRunner{
        .allocator = allocator,
        .io = io,
    };

    const input_path = try std.fmt.allocPrint(allocator, "inputs/day{d}.txt", .{day});
    const content = try Io.Dir.cwd().readFileAlloc(io, input_path, allocator, .unlimited);

    switch (day) {
        1 => try runner.run(@import("day1.zig"), day, content),
        else => {
            try stderr.print("Day {d} is not implemented.\n", .{day});
        },
    }
}
