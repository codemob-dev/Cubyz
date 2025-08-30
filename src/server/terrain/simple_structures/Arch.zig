const std = @import("std");

const main = @import("main");
const random = main.random;
const ZonElement = main.ZonElement;
const terrain = main.server.terrain;
const CaveBiomeMapView = terrain.CaveBiomeMap.CaveBiomeMapView;
const CaveMapView = terrain.CaveMap.CaveMapView;
const GenerationMode = terrain.biomes.SimpleStructureModel.GenerationMode;
const vec = main.vec;
const Vec3d = vec.Vec3d;
const Vec3f = vec.Vec3f;
const Vec3i = vec.Vec3i;
const NeverFailingAllocator = main.heap.NeverFailingAllocator;
const Boulder = @import("_list.zig").Boulder;

pub const id = "cubyz:arch";

pub const generationMode = .floor;

const Arch = @This();

block: main.blocks.Block,
horizontalMovement: f32,
verticalMovement: f32,
rockSizeMultiplier: f32,

pub fn loadModel(arenaAllocator: NeverFailingAllocator, parameters: ZonElement) *Arch {
	const self = arenaAllocator.create(Arch);
	self.* = .{
		.block = main.blocks.parseBlock(parameters.get([]const u8, "block", "cubyz:slate")),
		.horizontalMovement = parameters.get(f32, "horizontalMovement", 0.5),
		.verticalMovement = parameters.get(f32, "verticalMovement", 2.0),
		.rockSizeMultiplier = parameters.get(f32, "rockSizeMultiplier", 3.0),
	};
	return self;
}

pub fn generate(self: *Arch, genMode: GenerationMode, x: i32, y: i32, z: i32, chunk: *main.chunk.ServerChunk, caveMap: CaveMapView, caveBiomeMap: CaveBiomeMapView, seed: *u64, isCeiling: bool) void {
	var currentPos: Vec3f = .{@floatFromInt(x), @floatFromInt(y), @floatFromInt(z - 5)};

	var dir: Vec3f = .{(random.nextFloat(seed) - 0.5)*2*self.horizontalMovement, (random.nextFloat(seed) - 0.5)*2*self.horizontalMovement, random.nextFloat(seed) * self.verticalMovement};
	
	while(true) {
		const boulderSize = vec.length(dir)*self.rockSizeMultiplier;
		var boulder: Boulder = .{.block = self.block, .size = boulderSize, .sizeVariation = 0.0};
		boulder.generate(genMode, @intFromFloat(currentPos[0]), @intFromFloat(currentPos[1]), @intFromFloat(currentPos[2]), chunk, caveMap, caveBiomeMap, seed, isCeiling);
		if(@as(i32, @intFromFloat(currentPos[2])) < z - 15) break;
		currentPos += dir;
		dir[2] -= 0.1;
	}
}
