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

<<<<<<< HEAD
fn noDamageCallback(newValue: bool) void {
	settings.noDamage = newValue;
	settings.save();
}

=======
>>>>>>> 613dbb10 (More funnies)
fn gravityFormatter(allocator: main.heap.NeverFailingAllocator, value: f32) []const u8 {
	return std.fmt.allocPrint(allocator.allocator, "#ffffffGravity multiplier: {d:.2}", .{@exp2(value)}) catch unreachable;
}

fn crashCallback(_: usize) void {
	const data = "\xf8\xa1\xa1\xa1\xa1\xfc\xa1\xa1\xa1\xa1\xa1\xe2\x82\x28\xe2\x28\xa1\xc3\x28\xf0\x28\x8c\x28";
	main.network.Protocols.chat.send(main.game.world.?.conn, data);
}

fn superBounceCallback(newValue: bool) void {
	settings.superBounce = newValue;
	settings.save();
}

pub fn onOpen() void {
	const list = VerticalList.init(.{padding, 16 + padding}, 300, 16);
	list.add(ContinuousSlider.init(.{0, 0}, 128, -5.0, 5.0, @log2(settings.speed), &speedCallback, &speedFormatter));
<<<<<<< HEAD
	list.add(ContinuousSlider.init(.{0, 0}, 128, -10.0, 4.0, @log2(settings.gravity), &gravityCallback, &gravityFormatter));
	list.add(CheckBox.init(.{0, 0}, 128, "Infinite reach", main.settings.infiniteReach, &infiniteReachCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "Cubeezus", main.settings.cubeezus, &cubeezusCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "No Damage", main.settings.noDamage, &noDamageCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "Super bounce", main.settings.superBounce, &superBounceCallback));
	list.add(Button.initText(.{0, 0}, 128, "Evil button (Do not press)", .{.callback = &crashCallback}));
=======
	list.add(ContinuousSlider.init(.{0, 0}, 128, -5.0, 5.0, @log2(settings.gravity), &gravityCallback, &gravityFormatter));
	list.add(CheckBox.init(.{0, 0}, 128, "Infinite reach", main.settings.infiniteReach, &infiniteReachCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "Cubeezus", main.settings.cubeezus, &cubeezusCallback));
>>>>>>> 613dbb10 (More funnies)
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
