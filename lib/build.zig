const std = @import("std");
const napigen = @import("napigen");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.createModule(.{
        .root_source_file = b.path("root.zig"),
        .optimize = optimize,
        .target = target,
    });

    if (b.lazyDependency("ghostty", .{
        .target = target,
        .optimize = optimize,
    })) |dep| {
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

    const node_mod = b.createModule(.{
        .root_source_file = b.path("node.zig"),
        .optimize = optimize,
        .target = target,
    });

    const node_lib = b.addLibrary(.{
        .name = "example",
        .root_module = node_mod,
    });

    // Add napigen
    napigen.setup(node_lib);

    // Build the lib
    b.installArtifact(node_lib);

    // Copy the result to a *.node file so we can require() it
    const copy_node_step = b.addInstallLibFile(node_lib.getEmittedBin(), "example.node");
    b.getInstallStep().dependOn(&copy_node_step.step);
}
