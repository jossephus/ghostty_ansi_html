const std = @import("std");
const c = @cImport({
    @cInclude("node_api.h");
});
const ghostty_c = @import("root.zig");

export fn napi_register_module_v1(env: c.napi_env, exports: c.napi_value) c.napi_value {
    var new_convert_function: c.napi_value = undefined;
    if (c.napi_create_function(env, null, 0, NewConvert, null, &new_convert_function) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to create function");
        return null;
    }

    if (c.napi_set_named_property(env, exports, "NewConvert", new_convert_function) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to add function to exports");
        return null;
    }

    var convert_function: c.napi_value = undefined;
    if (c.napi_create_function(env, null, 0, convert, null, &convert_function) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to create function");
        return null;
    }

    if (c.napi_set_named_property(env, exports, "convert", convert_function) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to add function to exports");
        return null;
    }

    return exports;
}

fn NewConvert(env: c.napi_env, info: c.napi_callback_info) callconv(.c) c.napi_value {
    _ = info;

    const ptr = ghostty_c.NewConvert();
    var result: c.napi_value = undefined;
    if (c.napi_create_external(env, ptr, null, null, &result) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to create external");
        return null;
    }

    return result;
}

fn convert(env: c.napi_env, info: c.napi_callback_info) callconv(.c) c.napi_value {
    var argc: usize = 2;
    var args: [2]c.napi_value = undefined;
    if (c.napi_get_cb_info(env, info, &argc, &args, null, null) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to get callback info");
        return null;
    }

    if (argc != 2) {
        _ = c.napi_throw_error(env, null, "Expected 2 arguments");
        return null;
    }

    var convertor: *ghostty_c.GhosttyAnsiConvertor = undefined;
    if (c.napi_get_value_external(env, args[0], @as(*?*anyopaque, @ptrCast(&convertor))) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Invalid converter argument");
        return null;
    }

    var str_len: usize = undefined;
    if (c.napi_get_value_string_utf8(env, args[1], null, 0, &str_len) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to get string length");
        return null;
    }
    str_len += 1;
    const buf = std.heap.page_allocator.alloc(u8, str_len) catch {
        _ = c.napi_throw_error(env, null, "Allocation failed");
        return null;
    };
    defer std.heap.page_allocator.free(buf);

    if (c.napi_get_value_string_utf8(env, args[1], buf.ptr, str_len, null) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to get string");
        return null;
    }
    const c_str: [*:0]const u8 = @as([*:0]const u8, @ptrCast(buf.ptr));

    const html = ghostty_c.convert(convertor, c_str);
    defer {
        const html_slice = std.mem.span(html);
        std.heap.page_allocator.free(html_slice);
    }

    var result: c.napi_value = undefined;
    if (c.napi_create_string_utf8(env, html, c.NAPI_AUTO_LENGTH, &result) != c.napi_ok) {
        _ = c.napi_throw_error(env, null, "Failed to create string");
        return null;
    }

    return result;
}
