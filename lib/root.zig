const std = @import("std");
const ghostty_vt = @import("ghostty-vt");

pub const GhosttyAnsiConvertor = struct { terminal: ghostty_vt.Terminal };

const allocator = std.heap.page_allocator;

pub export fn NewConvert() *GhosttyAnsiConvertor {
    var conv = allocator.create(GhosttyAnsiConvertor) catch @panic("error allocating");
    conv.terminal = ghostty_vt.Terminal.init(allocator, .{ .cols = 150, .rows = 80 }) catch @panic("failed on initializing ghostty terminal ");
    return conv;
}

pub export fn convert(convertor: *GhosttyAnsiConvertor, value: [*:0]const u8) [*:0]const u8 {
    var stream = convertor.terminal.vtStream();
    defer stream.deinit();

    // Process the value
    var ptr = value;
    while (ptr[0] != 0) {
        const byte = ptr[0];
        if (byte == '\n') {
            stream.next('\r') catch @panic("error");
        }
        stream.next(byte) catch @panic("error");
        ptr += 1;
    }

    // Format to HTML
    const formatter: ghostty_vt.formatter.TerminalFormatter = ghostty_vt.formatter.TerminalFormatter.init(&convertor.terminal, .{
        .emit = .html,
        .palette = &convertor.terminal.colors.palette.current,
    });

    const html = std.fmt.allocPrint(allocator, "{f}", .{formatter}) catch @panic("alloc");
    var html_z = allocator.realloc(html, html.len + 1) catch @panic("realloc");
    html_z[html.len] = 0;
    return @as([*:0]const u8, @ptrCast(html_z.ptr));
}
