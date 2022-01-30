extends Node

const Grass = preload("res://scripts/blocks/Grass.gd")
const Dirt = preload("res://scripts/blocks/Dirt.gd")

var playerChunkPosition = null

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	var playerPosition = $Player.translation
	var newPlayerChunkPosition = Vector2(int(playerPosition.x) % 16, int(playerPosition.z) % 16)
	
	if newPlayerChunkPosition != playerChunkPosition:
		playerChunkPosition = newPlayerChunkPosition
		
		for x in range(playerChunkPosition.x - 1, playerChunkPosition.x + 1):
			for z in range(playerChunkPosition.y - 1, playerChunkPosition.y + 1):
				_createChunk(Vector2(x, z))

func _createChunk(chunkPosition):
	var realChunkPosition = Vector3(chunkPosition.x * 16, 0, chunkPosition.y * 16)
	
	for x in range(realChunkPosition.x, realChunkPosition.x + 16):
		for y in 256:
			for z in range(realChunkPosition.z, realChunkPosition.z + 16):
				var position = Vector3(x, y, z)
				var block = _getBlock(position)
				
				if block != null:
					block.translate(position)
					add_child(block)


const voxelVertices : Array = [
	Vector3(0,0,0),
	Vector3(1,0,0),
	Vector3(1,1,0),
	Vector3(0,1,0),
	Vector3(0,0,1),
	Vector3(1,0,1),
	Vector3(1,1,1),
	Vector3(0,1,1)
]

const voxelFaces : Array = [
	[3, 0, 1, 1, 2, 3], # back face
	[6, 5, 4, 4, 7, 6], # front face
	[7, 3, 2, 2, 6, 7], # top face
	[0, 4, 5, 5, 1, 0], # bottom face
	[7, 4, 0, 0, 3, 7], # left face
	[2, 1, 5, 5, 6, 2] # right face
]

const voxelUVs : Array = [
	Vector2(0,1),
	Vector2(0,0),
	Vector2(1,0),
	Vector2(1,0),
	Vector2(1,1),
	Vector2(0,1)
]

func _getBlock(position: Vector3):
	if position.y > 64 or position.y < 60:
		return null
	else:
		var surfaceTool = SurfaceTool.new()
		surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		var mat = SpatialMaterial.new()
		mat.params_cull_mode = SpatialMaterial.CULL_DISABLED # TODO fix
		mat.vertex_color_use_as_albedo = SpatialMaterial.FLAG_ALBEDO_FROM_VERTEX_COLOR
		surfaceTool.set_material(mat)
		
		for i in range(voxelFaces.size()):
			for j in range(6):
				surfaceTool.add_color(Grass.voxelFaceColors[i])
				surfaceTool.add_uv(voxelUVs[j])
				surfaceTool.add_vertex(voxelVertices[voxelFaces[i][j]])

		surfaceTool.generate_normals()

		var meshInstance = MeshInstance.new()
		var mesh : Mesh = surfaceTool.commit()
		meshInstance.mesh = mesh
		
		var boxShape = BoxShape.new()
		boxShape.extents = Vector3(0.5, 0.5, 0.5)
		
		var collisionShape = CollisionShape.new()
		collisionShape.shape = boxShape
		
		var staticBody: StaticBody = StaticBody.new()
		staticBody.scale = Vector3(0.5, 0.5, 0.5)
		staticBody.add_child(meshInstance)
		staticBody.add_child(collisionShape)
		

		return staticBody

