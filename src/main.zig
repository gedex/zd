const std = @import("std");
const print = std.debug.print;
const window = std.mem.window;
const isPrint = std.ascii.isPrint;

const usage =
    \\Usage: zd <file>
;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn die(comptime format: []const u8, args: anytype) noreturn {
    ret: {
        const msg = std.fmt.allocPrint(allocator, format ++ "\n", args) catch break :ret;
        std.io.getStdErr().writeAll(msg) catch {};
    }
    std.process.exit(1);
}

pub fn main() !void {
    const proc_args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, proc_args);

    const args = proc_args[1..];
    if (args.len == 0) die(usage, .{});

    const file = std.fs.cwd().openFile(args[0], .{}) catch {
        die("error opening file {s}", .{args[0]});
        return;
    };
    defer file.close();

    const file_size = (try file.stat()).size;
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    _ = try file.readAll(buffer);

    try dump(buffer);
}

pub fn byteToHex(b: u8) [2]u8 {
    const charset = "0123456789abcdef";
    var result: [2]u8 = undefined;
    result[0] = charset[b >> 4];
    result[1] = charset[b & 15];
    return result;
}

pub fn dump(data: []u8) !void {
    const cols = 16;

    var offset: u32 = 0;
    var it = window(u8, data, cols, cols);
    while (it.next()) |line| {
        // Offset.
        print("{x:0>8}: ", .{offset});
        offset += cols;

        // Hex format.
        var i: usize = 0;
        while (i < cols) : (i += 2) {
            const c1 = if (line.len > i) byteToHex(line[i]) else [2]u8{' ', ' '};
            const c2 = if (line.len > (i+1)) byteToHex(line[i+1]) else [2]u8{' ', ' '};
            print("{s}{s} ", .{c1, c2});
        }

        // Printable.
        print(" ", .{});
        for (line) |char| {
            if (isPrint(char)) {
                print("{c}", .{char});
            } else {
                print(".", .{});
            }
        }

        print("\n", .{});
    }
}
