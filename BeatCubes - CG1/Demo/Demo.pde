import ddf.minim.*;
import ddf.minim.analysis.FFT;
import moonlander.library.*;

class DemoCube {
	float x;
	float y;
	float z;
	float h;
	int r;
	int g;
	int b;

	DemoCube(float x, float y, float z, float h) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.h = h;
		this.r = 0;
		this.g = 0;
		this.g = 0;
	}

	float getX() {
		return this.x;
	}

	float getY() {
		return this.y;
	}

	float getZ() {
		return this.z;
	}

	float getH() {
        return this.h;
    }

	void setX(float x) {
		this.x = x;
	}

	void setY(float y) {
		this.y = y;
	}

	void setZ(float z) {
		this.z = z;
	}

	void setH(float h) {
		this.h = h;
	}

	int getR() {
		return this.r;
	}

	int getG() {
		return this.g;
	}

	int getB() {
		return this.b;
	}

	void draw() {
		pushMatrix();
		translate(this.x, this.y, this.z);
		stroke(255, 0, 0);
		fill(this.r, this.g, this.b);
		box(20, h, 20);
		popMatrix();
	}

	void draw(float r, float g, float b) {
		pushMatrix();
		translate(this.x, this.y, this.z);
		stroke(255, 0, 0);
		fill(r, g, b);
		box(20, h, 20);
		popMatrix();
	}

	void flash(int r, int g, int b) {
		this.r = r;
		this.g = g;
		this.b = b;
	}
}

final int CANVAS_WIDTH = 1920;
final int CANVAS_HEIGHT = 1080;
final int CUBES_IN_ROW = 64;
final int CUBES_IN_COLUMN = 32;
final int CUBE_WIDTH = 25;
final int CUBE_HEIGHT = 20;
int FLASH_ROW = 0;
int FLASH_ROW_DIRECTION = 1;
float WAVE_HEIGHT = 0;
int TEXT_Y_POS_OFFSET = 500;
DemoCube[][] cubes = new DemoCube[CUBES_IN_ROW][CUBES_IN_COLUMN];

Minim minim;
AudioPlayer song;
FFT fft;
Moonlander moonlander;

void setup() {
    size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);

    noStroke();
    frameRate(30);
    smooth();

    initCubes();

    setupAudio();
}

void setupAudio() {
    minim = new Minim(this);
    song = minim.loadFile("Rune_Factory_-_8_Bit_Adventurer_short.wav");
    moonlander = Moonlander.initWithSoundtrack(this, "dialup.wav", 127, 8);
    fft = new FFT(song.bufferSize(), song.sampleRate());

    moonlander.start();
}

void draw() {
    moonlander.update();
    background(0, 0, 0);

    float secs = millis() / 1000.0;

    int startWaves = (int) moonlander.getValue("startWaves");

    if (startWaves != 0 || song.isPlaying()) {
        fft.forward(song.mix);
        cubeWaves(secs);
    }

    int startSong = (int) moonlander.getValue("startSong");

    if (startSong != 0 && !song.isPlaying()) {
        song.play();
    }

    if (secs > 52) {
        exit();
    }

    translate(width / 2, height / 2, 0);

    flashRows(FLASH_ROW);
    if (secs > FLASH_ROW / 100) {
        int flashRowLoop = (int) moonlander.getValue("flashRowLoop");
        if (flashRowLoop == 1) {
            FLASH_ROW += FLASH_ROW_DIRECTION;
            if (FLASH_ROW == CUBES_IN_ROW) {
                FLASH_ROW_DIRECTION = -1;
                FLASH_ROW += FLASH_ROW_DIRECTION;
            }
            if (FLASH_ROW < 0) {
                FLASH_ROW_DIRECTION = 1;
                FLASH_ROW += FLASH_ROW_DIRECTION;
            }
        } else {
            FLASH_ROW = ++FLASH_ROW % CUBES_IN_ROW;
        }
    }

    translate(0, 100, -50);
    fill(255);

    if (song.position() / 1000.0 > 24)
        drawText();

    pushMatrix();
    rotateX(12.3);
    drawCubes();
    callCubes();
    popMatrix();


}

void callCubes() {
    int x = (int) moonlander.getValue("x");
    int y = (int) moonlander.getValue("y");

    if (x == 0 || y == 0)
        return;

    cubes[x][y].setH(40);
    cubes[x][y].draw(0, 255, 0);

    int start_x = x > 5 ? x - 5 : 0;
    int start_y = y > 5 ? y - 5 : 0;
    int end_x = x + 5 > CUBES_IN_ROW ? CUBES_IN_ROW : x + 5;
    int end_y = y + 5 > CUBES_IN_COLUMN ? CUBES_IN_COLUMN : y + 5;

    for (int i = start_x; i < end_x; i++) {
        for (int j = start_y; j < end_y; j++) {
            cubes[i][j].draw(0, 255 * (1 /  dist(x, y, i, j)), 0);
        }
    }
}

void drawText() {
    if (TEXT_Y_POS_OFFSET > 70) {
        TEXT_Y_POS_OFFSET -= 8;
    }
    pushMatrix();
    textSize(72);
    fill(255, 0, 0);
    text("BeatCubes", -CANVAS_WIDTH / 2 - 100, -CANVAS_HEIGHT / 2 + 150 - TEXT_Y_POS_OFFSET, -100);
    textSize(24);
    text("Music: 8 Bit Adventurer by Rune Factory",
         -CANVAS_WIDTH / 2 - 100, -CANVAS_HEIGHT / 2	 - TEXT_Y_POS_OFFSET, -100);
    popMatrix();

}

void cubeWaves(float secs) {
    for (int i = 0; i < CUBES_IN_ROW; i++)
        for (int j = 0; j < CUBES_IN_COLUMN; j++) {
            cubes[i][j].setY((sin(secs * 5 + i) * 10 * WAVE_HEIGHT
                              + sin(secs * 5 + j) * 10 * 0.3) * WAVE_HEIGHT);
        }
    if (WAVE_HEIGHT < 1 && song.position() / 1000.0 < 27)
        WAVE_HEIGHT += 0.05;
    else if (WAVE_HEIGHT > 0)
        WAVE_HEIGHT -= 0.05;
    else if (song.position() / 1000.0 < 29)
        song.close();
}

void initCubes() {
    for (int i = 0; i < CUBES_IN_ROW; i++)
        for (int j = 0; j < CUBES_IN_COLUMN; j++) {
            cubes[i][j] = new DemoCube(CUBE_WIDTH * i - CUBES_IN_COLUMN * CUBE_WIDTH,
                                       0, -CUBE_WIDTH * j, 20);
        }
}

void drawCubes() {
    for (int i = 0; i < CUBES_IN_ROW; i++)
        for (int j = 0; j < CUBES_IN_COLUMN; j++) {
            cubes[i][j].draw();
        }
}

void flashRows(int row) {
    for (int i = 0; i < CUBES_IN_ROW; i++) {
        if (i == row) {
            continue;
        }
        for (int j = 0; j < CUBES_IN_COLUMN; j++) {
            cubes[i][j].flash(floor(cubes[i][j].getR() * 0.7),
                              floor(cubes[i][j].getG() * 0.7),
                              floor(cubes[i][j].getB() * 0.7));
            float newH = cubes[i][j].getH();
            if (cubes[i][j].getH() > CUBE_HEIGHT)
                newH -= 5;
            else
                newH = CUBE_HEIGHT;
            cubes[i][j].setH(newH);
        }
    }

    final float highestH = fft.getBand(fft.specSize() / (row + 1)) * 10;
    for (int i = 0; i < CUBES_IN_COLUMN; i++) {
        int flashColorRed = (int)moonlander.getValue("flashColorRed");
        int flashColorGreen = (int)moonlander.getValue("flashColorGreen");
        int flashColorBlue = (int)moonlander.getValue("flashColorBlue");
        cubes[row][i].flash(flashColorRed, flashColorGreen, flashColorBlue);
        float newH = highestH - 10 * (i < 16 ? (16 - i) : (i - 16));
        if (newH < CUBE_HEIGHT)
            newH = CUBE_HEIGHT;
        cubes[row][i].setH(newH);
    }
}
