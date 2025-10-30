const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .optimize = optimize,
        .target = target,
    });

    if (b.lazyDependency("ghostty", .{})) |dep| {
        mod.addImport(
            "ghostty-vt",
            dep.module("ghostty-vt"),
        );
    }

    const root_lib = b.addLibrary(.{
        .name = "ghostty-ansi-html",
        .root_module = mod,
        .linkage = .dynamic,
    });

    b.installArtifact(root_lib);
}
