const std = @import("std");

const CD_PREFIX = "$ cd ";
const DIR_PREFIX = "dir ";
const LS_PREFIX = "$ ls";

const DEBUG_MODE = false;

fn debug(comptime format: []const u8, args: anytype) void {
    if (DEBUG_MODE) {
        _ = stdout.print(format, args);
    }
}

const Directory = struct {
    name: []const u8,
    parent: ?*Directory,
    entries: std.ArrayList(Entry),

    fn init(alloc: std.mem.Allocator, name: []const u8, parent: ?*Directory) Directory {
        return .{ .name = name, .parent = parent, .entries = std.ArrayList(Entry).init(alloc) };
    }

    fn find(dir: *Directory, name: []const u8) ?*Entry {
        for (dir.entries.items) |_, i| {
            var item = &dir.entries.items[i];
            if (std.mem.eql(u8, item.name(), name)) {
                return item;
            }
        }
        return null;
    }

    fn findOrAddDirectory(dir: *Directory, name: []const u8) !*Directory {
        if (dir.find(name)) |d| {
            return &d.directory;
        } else {
            try dir.entries.append(Entry{ .directory = Directory.init(dir.entries.allocator, name, dir) });
            return &dir.entries.items[dir.entries.items.len - 1].directory;
        }
    }

    fn findOrAddFile(dir: *Directory, name: []const u8) !*File {
        if (dir.find(name)) |d| {
            return &d.file;
        } else {
            try dir.entries.append(Entry{ .file = File{ .name = name, .size = 0 } });
            return &dir.entries.items[dir.entries.items.len - 1].file;
        }
    }

    fn print(self: Directory) void {
        stdout.print("start of directory {s}\n", .{self.name}) catch unreachable;
        for (self.entries.items) |item| {
            item.print();
        }
        stdout.print("end of directory {s}\n", .{self.name}) catch unreachable;
    }
};

const File = struct {
    name: []const u8,
    size: u64,

    fn print(self: File) void {
        stdout.print("file {s} size {any}\n", .{ self.name, self.size }) catch unreachable;
    }
};

const Entry = union(enum) {
    directory: Directory,
    file: File,

    fn name(self: Entry) []const u8 {
        return switch (self) {
            Entry.directory => |dir| dir.name,
            Entry.file => |file| file.name,
        };
    }

    fn print(self: Entry) void {
        switch (self) {
            Entry.directory => |dir| dir.print(),
            Entry.file => |file| file.print(),
        }
    }
};

const MAX_DIRECTORY_SIZE = 100000;

fn find_total(sum: *u64, directory: Directory) u64 {
    var total: u64 = 0;
    for (directory.entries.items) |item| {
        switch (item) {
            Entry.directory => |subdir| total += find_total(sum, subdir),
            Entry.file => |file| total += file.size,
        }
    }

    if (total < MAX_DIRECTORY_SIZE) {
        sum.* += total;
    }

    return total;
}

var required_space_to_free: u64 = 0;

fn find_smallest_to_delete(min: *u64, directory: Directory) u64 {
    var total: u64 = 0;
    for (directory.entries.items) |item| {
        switch (item) {
            Entry.directory => |subdir| total += find_smallest_to_delete(min, subdir),
            Entry.file => |file| total += file.size,
        }
    }

    if (total > required_space_to_free and total < min.*) {
        min.* = total;
    }

    return total;
}

fn solution(root: Directory) void {
    var sum: u64 = 0;
    var min: u64 = 1 << 63;

    required_space_to_free = 30000000 - (70000000 - find_total(&sum, root));
    _ = find_smallest_to_delete(&min, root);

    stdout.print("{any}\n", .{sum}) catch unreachable;
    stdout.print("{any}\n", .{min}) catch unreachable;
}

var stdout: @TypeOf(std.io.getStdOut().writer()) = undefined;

pub fn main() !void {
    stdout = std.io.getStdOut().writer();

    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gp.deinit();
    const gpa = gp.allocator();
    var arena_instance = std.heap.ArenaAllocator.init(gpa);
    defer arena_instance.deinit();
    const arena = arena_instance.allocator();

    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var root = Directory.init(arena, "/", null);
    var current: *Directory = &root;

    while (try in_stream.readUntilDelimiterOrEofAlloc(arena, '\n', 256)) |line| {
        if (std.mem.startsWith(u8, line, CD_PREFIX)) {
            var name = line[CD_PREFIX.len..];
            debug("cd: {s}\n", .{name});

            if (std.mem.eql(u8, name, "/")) {
                current = &root;
            } else if (std.mem.eql(u8, name, "..")) {
                current = current.parent orelse &root;
            } else {
                current = try current.findOrAddDirectory(name);
            }

            continue;
        }

        if (std.mem.startsWith(u8, line, DIR_PREFIX)) {
            var name = line[DIR_PREFIX.len..];
            debug("dir: {s}\n", .{name});
            continue;
        }

        if (std.mem.startsWith(u8, line, LS_PREFIX)) {
            continue;
        }

        if (std.mem.indexOf(u8, line, " ")) |split| {
            var size = line[0..split];
            var name = line[split + 1 ..];
            debug("file: {s}, size: {s}\n", .{ name, size });
            (try current.findOrAddFile(name)).size = try std.fmt.parseInt(u64, size, 10);
        }
    }

    solution(root);
}
