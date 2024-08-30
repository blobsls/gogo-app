const std = @import("std");
const process = std.process;
const fs = std.fs;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <ruby_script.rb>\n", .{args[0]});
        return;
    }

    const ruby_script = args[1];

    const ruby_command = [_][]const u8{
        "ruby",
        ruby_script,
    };

    const result = try std.ChildProcess.exec(.{
        .allocator = allocator,
        .argv = &ruby_command,
    });

    defer allocator.free(result.stdout);
    defer allocator.free(result.stderr);

    switch (result.term) {
        .Exited => |code| {
            if (code == 0) {
                std.debug.print("Ruby script executed successfully.\n", .{});
                std.debug.print("Output:\n{s}\n", .{result.stdout});
            } else {
                std.debug.print("Ruby script exited with code {}.\n", .{code});
                std.debug.print("Error output:\n{s}\n", .{result.stderr});
            }
        },
        else => std.debug.print("Ruby script execution failed.\n", .{}),
    }
}
