


class Letter {
 int[][] array;
 int startX = 0;
 int startY = 0; 
 boolean vertical = false;
 boolean reverseOffset = false;
 boolean reverseLetters = false;
 
 Letter(int startX, int startY, boolean vertical, boolean reverseLetters, boolean reverseOffset) {
  this.vertical = vertical;
  this.reverseOffset = reverseOffset;
  this.reverseLetters = reverseLetters;
  this.startX = startX;
  this.startY = startY;
  array = new int[0][0];
 } 
 
 void updateActive(boolean[][] active, int letterOffset) {
   letterOffset = reverseOffset ? -letterOffset : letterOffset;
   for (int i = 0; i < array.length; ++i) {
     for (int j = 0; j < array[i].length; ++j) {
       int x = startX + j - (vertical ? 0 : letterOffset);
       int y = startY + i - (vertical ? letterOffset : 0); 
       if (y >= 0 && y < active.length && x >= 0 && x < active[y].length && array[i][reverseLetters ? array[i].length - j - 1: j] == 1) {
         active[y][x] = true; 
       }
     }
   }  
 }
}

class Letters {
  Letter[] letters;
  float[][] randoms;
  int letterOffset = 0;
  int resX = 120;
  int resY = 48;
  float offset = 0;
  float offsetSpeed = 0.1;
  int counter = 0;
  
  void init() {
    letters = new Letter[21];
    randoms = new float[resY][resX];
    for ( int i = 0; i < resY; ++i) {
      for ( int j = 0; j < resX; ++j) {
         randoms[i][j] = random(1.0, 1.5);
      } 
    }
    for (int i = 0; i < 4; ++i) {
       letters[i] = new Letter(35, resY + 5 + 15 * i, true, false, false); 
    }
    for (int i = 4; i < 11; ++i) {
       letters[i] = new Letter(120 + i * 10, 30, false, false, false); 
    } 
    for (int i = 11; i < 21; ++i) {
       letters[i] = new Letter(-20 - i * 10, 10, false, true, true); 
    } 
    
    letters[0].array = new int[][] {
      {1, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 0},
    };
    
    letters[1].array = new int[][] {
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 1, 1, 1},
      {0, 0, 0, 0, 1, 1, 1},
      {0, 0, 0, 0, 1, 1, 1},
      {0, 0, 0, 0, 1, 1, 1},
      {0, 0, 0, 0, 1, 1, 1},
    };
    
    letters[2].array = new int[][] {
      {1, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
    };
    
    letters[3].array = new int[][] {
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
    };
    
    letters[4].array = new int[][] {
      {0, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
    };
    
    letters[5].array = new int[][] {
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {0, 1, 1, 1, 1, 1, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 0, 1, 0, 0, 0},
    };
    
    letters[6].array = letters[4].array;
    
    letters[7].array = new int[][] {
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
    };
    
    letters[8].array = new int[][] {
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
    };
    
    letters[9].array = new int[][] {
      {1, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
    };
    
    letters[10].array = new int[][] {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
    };
    
    letters[11].array = new int[][] {
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
    };
    
    letters[12].array = letters[4].array;
    
    letters[13].array = new int[][] {
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {0, 1, 1, 1, 1, 1, 0},
    };
    
    letters[14].array = letters[2].array;
   
    letters[15].array = letters[4].array;
   
    letters[16].array = letters[11].array;
   
    letters[17].array = new int[][] {
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
    };
    
    letters[18].array = letters[11].array;
   
    letters[19].array = new int[][] {
      {0, 1, 1, 1, 1, 1, 0},
      {1, 1, 1, 1, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 0, 0, 0, 0},
      {1, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 1, 1, 1},
      {0, 0, 0, 0, 1, 1, 1},
      {1, 1, 1, 0, 1, 1, 1},
      {1, 1, 1, 1, 1, 1, 1},
      {0, 1, 1, 1, 1, 1, 0},
    };
    
    letters[20].array = new int[][] {
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
    };
  }
  
  void draw(float time) {
    background(0);
    drawCanvas(time);
  }
  
  void drawCanvas(float time) {
    
   float rotTime = -1;
   float newLetterOffset = time / 20.0;
   if (newLetterOffset < 231)
     letterOffset = round(newLetterOffset);
   else
     letterOffset = 231;
   if (newLetterOffset > 220) {
     translate(width / 2, 0, 0);
     rotTime = newLetterOffset - 220;
     float rot = rotTime * rotTime * 0.002;
     rotateY(min(rot, PI)); 
     translate(-width / 2, 0, 0);
     rotTime = rot - PI;
   }
   
    
   boolean active[][] = new boolean[resY][resX];
   for ( int i = 0; i < letters.length; ++i) {
    letters[i].updateActive(active, letterOffset); 
   }
   
   offset = time / 120.0;
    
   noStroke();
   float spacingX = (float)width / (resX - 1);
   float spacingY = (float)height / (resY - 1);
   for ( int j = 0; j < resY; j++) {
     float change = sin(j * 0.5 - offset) ;
     fill(128 - change * 100, 128 + change * 100, 155);
     for (int i = 0; i < resX; i++) {
       pushMatrix();
       float ballX = rotTime > 0 ? 0 : 0;
       float ballY = rotTime > 0 ? (-rotTime * 40.0 * randoms[j][i] + rotTime * rotTime * 18.0) : 0;
       translate(ballX, ballY, change * 10);
       float scale = active[j][i] ? 10 : 3;
       ellipse(i * spacingX, j * spacingY, scale, scale); 
       popMatrix();
     }
   }  
  }
}
