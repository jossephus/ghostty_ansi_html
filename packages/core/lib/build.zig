const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_node = b.option(bool, "build_node", "Specify if this will be a node build ") orelse false;

    const mod = if (!build_node) b.createModule(.{
        .root_source_file = b.path("root.zig"),
        .optimize = optimize,
        .target = target,
    }) else b.createModule(.{
        .root_source_file = b.path("node.zig"),
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

    const root_lib = if (!build_node) b.addLibrary(.{
        .name = "ghostty-ansi-html",
        .root_module = mod,
        .linkage = .dynamic,
    }) else b.addLibrary(.{
        .name = "ghostty-ansi-html",
        .root_module = mod,
        .linkage = .dynamic,
    });

    if (build_node) {
        const node_api = b.dependency("node_api", .{});
        root_lib.addIncludePath(node_api.path("include"));

        if (target.result.os.tag == .windows) {
            root_lib.linkSystemLibrary("node.lib");

            // From: https://github.com/cztomsik/napigen/commit/007b4bc8751cf78879288048013fbb62e050a072
            const node_lib = b.addSystemCommand(&.{ b.graph.zig_exe, "dlltool", "-m", "i386:x86-64", "-D", "node.exe", "-l", "node.lib", "-d" });
            node_lib.addFileArg(node_api.path("def/node_api.def"));
            // TODO: find a better way (this will end up outside of .zig-cache)
            node_lib.cwd = .{ .cwd_relative = b.makeTempPath() };
            root_lib.step.dependOn(&node_lib.step);

            root_lib.addLibraryPath(node_lib.cwd.?);
            root_lib.linkSystemLibrary("node");
        }

        b.installArtifact(root_lib);

        const copy_node_step = b.addInstallLibFile(root_lib.getEmittedBin(), "libghostty-ansi-html.node");
        b.getInstallStep().dependOn(&copy_node_step.step);
    } else {
        b.installArtifact(root_lib);
    }
}
