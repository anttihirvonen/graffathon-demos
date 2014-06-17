float cardinal(float prev, float cur, float next, float nextnext, float t, float c) {
  float t2 = t * t;
  float t3 = t * t2;
  float result = 0;

  float m0 = (next - prev)  * (1.0 - c) / 2.0;
  float m1 = (nextnext - cur)  * (1.0 - c) / 2.0;


  result += (2*t3 - 3*t2 + 1) * cur;
  result += (t3 - 2*t2 + t) * m0;
  result += (-2 * t3 + 3*t2) * next;
  result += (t3 - t2) * m1;

  return result;
}

Mesh interpolate(Mesh input, int num, float c) {
  Mesh result = new Mesh(num);

  float tDelta = (float)input.x.length / (float)num;
  float t = 0;
  int inputIndex = 0;

  for (int i = 0; i < num; ++i) {
    while (t > 1.0) {
      t -= 1.0;
      ++inputIndex;
    }

    int prevIndex = inputIndex - 1;
    int nextIndex = inputIndex + 1;
    int nextNextIndex = inputIndex + 2;

    if (prevIndex < 0) prevIndex = input.x.length - 1;
    if (nextIndex >= input.x.length) nextIndex -= input.x.length;
    if (nextNextIndex >= input.x.length) nextNextIndex -= input.x.length;

    result.x[i] = cardinal(
      input.x[prevIndex],
      input.x[inputIndex],
      input.x[nextIndex],
      input.x[nextNextIndex],
      t,
      c);

    result.y[i] = cardinal(
      input.y[prevIndex],
      input.y[inputIndex],
      input.y[nextIndex],
      input.y[nextNextIndex],
      t,
      c);

    t += tDelta;
  }

  return result;
}

