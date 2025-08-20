const std = @import("std");

const graphics = @import("graphics.zig");
const main = @import("main.zig");
const utils = main.utils;
const Array2D = main.utils.Array2D;
const Color = graphics.Color;
const NeverFailingAllocator = main.heap.NeverFailingAllocator;

var noiseMaps: std.StringHashMap(NoiseMap) = undefined;

pub const NoiseMap = struct {
	data: Array2D(f32),
	pub fn init(allocator: NeverFailingAllocator, texturePath: []const u8) NoiseMap {
		const image = graphics.Image.readFromFile(allocator, texturePath) catch {
			std.log.err("Noise map {s} not found!", .{texturePath});
		};
		defer image.deinit(allocator);

		var data: Array2D(f32) = .init(allocator, image.width, image.height);
		for(0.., image.imageData) |i, color| {
			data.mem[i] = (@as(f32, @floatFromInt(color.r)) + @as(f32, @floatFromInt(color.g)) + @as(f32, @floatFromInt(color.b)))/3.0;
		}
		return NoiseMap{data};
	}
	pub fn deinit(self: *NoiseMap, allocator: NeverFailingAllocator) void {
		self.data.deinit(allocator);
	}
	pub fn valueAt(self: *NoiseMap, x: i32, y: i32) f32 {
		return self.data.get(@intCast(@mod(x, @as(i32, @intCast(self.data.width)))), @intCast(@mod(y, @as(i32, @intCast(self.data.height)))));
	}
};

pub fn init() void {
	const allocator = main.globalAllocator;
	noiseMaps = .init(allocator.allocator);
	const data: Array2D(f32) = .init(allocator, 64, 64);
	for(0..64) |x| {
		for(0..64) |y| {
			const fx = @as(f32, @floatFromInt(x))/32.0 - 1.0;
			const fy = @as(f32, @floatFromInt(y))/32.0 - 1.0;

			const value = 1.0/(fx*fx + fy*fy + 1.0);
			data.set(x, y, value);
		}
	}
	noiseMaps.putNoClobber("cubyz:test", .{.data = data}) catch unreachable;
}

pub fn getMap(id: []const u8) ?*NoiseMap {
	return noiseMaps.getPtr(id);
}

pub fn deinit() void {
	var iterator = noiseMaps.valueIterator();
	while(iterator.next()) |map| {
		map.deinit(main.globalAllocator);
	}
	noiseMaps.deinit();
}