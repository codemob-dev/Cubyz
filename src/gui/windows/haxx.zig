const std = @import("std");

const main = @import("main");
const settings = main.settings;
const Vec2f = main.vec.Vec2f;

const gui = @import("../gui.zig");
const GuiComponent = gui.GuiComponent;
const GuiWindow = gui.GuiWindow;
const Button = @import("../components/Button.zig");
const CheckBox = @import("../components/CheckBox.zig");
const ContinuousSlider = @import("../components/ContinuousSlider.zig");
const DiscreteSlider = @import("../components/DiscreteSlider.zig");
const VerticalList = @import("../components/VerticalList.zig");

pub var window = GuiWindow{
	.contentSize = Vec2f{128, 256},
	.closeIfMouseIsGrabbed = true,
};

const padding: f32 = 8;

fn speedCallback(newValue: f32) void {
	settings.speed = @exp2(newValue);
	settings.save();
}

fn speedFormatter(allocator: main.heap.NeverFailingAllocator, value: f32) []const u8 {
	return std.fmt.allocPrint(allocator.allocator, "#ffffffSpeed: {d:.2}", .{@exp2(value)}) catch unreachable;
}

fn gravityCallback(newValue: f32) void {
	settings.gravity = @exp2(newValue);
	settings.save();
}

fn infiniteReachCallback(newValue: bool) void {
	settings.infiniteReach = newValue;
	settings.save();
}

fn cubeezusCallback(newValue: bool) void {
	settings.cubeezus = newValue;
	settings.save();
}

fn gravityFormatter(allocator: main.heap.NeverFailingAllocator, value: f32) []const u8 {
	return std.fmt.allocPrint(allocator.allocator, "#ffffffGravity multiplier: {d:.2}", .{@exp2(value)}) catch unreachable;
}

pub fn onOpen() void {
	const list = VerticalList.init(.{padding, 16 + padding}, 300, 16);
	list.add(ContinuousSlider.init(.{0, 0}, 128, -5.0, 5.0, @log2(settings.speed), &speedCallback, &speedFormatter));
	list.add(ContinuousSlider.init(.{0, 0}, 128, -5.0, 5.0, @log2(settings.gravity), &gravityCallback, &gravityFormatter));
	list.add(CheckBox.init(.{0, 0}, 128, "Infinite reach", main.settings.infiniteReach, &infiniteReachCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "Cubeezus", main.settings.cubeezus, &cubeezusCallback));
	list.finish(.center);
	window.rootComponent = list.toComponent();
	window.contentSize = window.rootComponent.?.pos() + window.rootComponent.?.size() + @as(Vec2f, @splat(padding));
	gui.updateWindowPositions();
}

pub fn onClose() void {
	if(window.rootComponent) |*comp| {
		comp.deinit();
	}
}
