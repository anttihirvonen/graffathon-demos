class MeshSet {
  Mesh meshes[];
  float parameters[];

  int meshSize;

  MeshSet(int numMeshes, int meshSize) {
    meshes = new Mesh[numMeshes];
    parameters = new float[numMeshes];
    this.meshSize = meshSize;
  }

  void setMesh(int index, Mesh mesh, float c) {
    if (meshSize != mesh.x.length) {
      meshes[index] = interpolate(mesh, meshSize, c);
    }
    else {
      meshes[index] = mesh;
    }
  }

  Mesh getMesh() {
    Mesh result = new Mesh(meshSize);
    for (int i = 0; i < meshes.length; ++i) {
      for (int j = 0; j < meshSize; ++j) {
        result.x[j] += meshes[i].x[j] * parameters[i];
        result.y[j] += meshes[i].y[j] * parameters[i];
      }
    }
    return result;
  }
}

