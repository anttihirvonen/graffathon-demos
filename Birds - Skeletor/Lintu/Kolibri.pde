class Kolibri
{
  float size;
  float x;
  float y;
  float z;
  int fly = 1;
  int degree = 0;
  float radian;
  pLintu[] paa = new pLintu[2];
  pLintu[] torso = new pLintu[9];
  pLintu[] vasen = new pLintu[15];
  pLintu[] oikea = new pLintu[15];
  pLintu[] pyrsto = new pLintu[3];
  
  
  Kolibri(float newsize,float centerX,float centerY,float centerZ)
  {
    size = newsize;
    x = centerX;
    y = centerY;
    z = centerZ;
    
    //pää
    paa[0] = new pLintu(0,size*3/2,0,0,size*2/6,0);
    paa[1] = new pLintu(0,size,0,0,size*5/3,0);
    
    //torso
    
    torso[0] = new pLintu(0,size,0,0,0,0);
    torso[1] = new pLintu(torso[0].leftX(),torso[0].leftY(),0,torso[0].leftX(),0,0);
    torso[2] = new pLintu(torso[0].rightX(),torso[0].rightY(),0,torso[0].rightX(),0,0);
    torso[3] = new pLintu(0,torso[1].rightY(),0,0,-size*11/10,0);
    torso[4] = new pLintu(torso[1].leftX(),torso[1].leftY(),0,torso[1].leftX(),-size*2/9,0);
    torso[5] = new pLintu(torso[2].rightX(),torso[2].rightY(),0,torso[2].rightX(),-size*2/9,0);
    torso[6] = new pLintu(torso[4].rightX(),torso[4].rightY(),0,torso[4].rightX(),-size*6/9,0);
    torso[7] = new pLintu(torso[5].leftX(),torso[5].leftY(),0,torso[5].leftX(),-size*6/9,0);
    torso[8] = new pLintu(0,size*3/6,0,0,-size*3/9,0);
    
    //vasen siipi
    vasen[0] = new pLintu(size*10/3,size,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[1] = new pLintu(size*10/3,size*3/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[2] = new pLintu(size*10/3,size*2/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[3] = new pLintu(size*13/4,size*0,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[4] = new pLintu(size*3,size*-1/2,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[5] = new pLintu(size*8/3,size*-1,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[6] = new pLintu(size*2,size*-3/2,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
   
    
    vasen[7] = new pLintu(size*5/3,size*3/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[8] = new pLintu(size*5/3,size*2/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[9] = new pLintu(size*3/2,size*1/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[10] = new pLintu(size*3/2,size*0,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[11] = new pLintu(size*4/3,size*-1/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[12] = new pLintu(size*5/4,size*-2/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[13] = new pLintu(size,size*-3/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    vasen[14] = new pLintu(size*2/3,size*-1,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    
    //oikea siipi
    oikea[0] = new pLintu(-size*10/3,size,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[1] = new pLintu(-size*10/3,size*3/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[2] = new pLintu(-size*10/3,size*2/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[3] = new pLintu(-size*13/4,size*0,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[4] = new pLintu(-size*3,size*-1/2,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[5] = new pLintu(-size*8/3,size*-1,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[6] = new pLintu(-size*2,size*-3/2,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
   
    oikea[7] = new pLintu(-size*5/3,size*3/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[8] = new pLintu(-size*5/3,size*2/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[9] = new pLintu(-size*3/2,size*1/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[10] = new pLintu(-size*3/2,size*0,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[11] = new pLintu(-size*4/3,size*-1/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[12] = new pLintu(-size*5/4,size*-2/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[13] = new pLintu(-size,size*-3/4,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    oikea[14] = new pLintu(-size*2/3,size*-1,0,torso[1].rightX(),torso[1].rightY(),torso[1].rightZ());
    
    
    //pyrstö
    
    pyrsto[0]= new pLintu(size/2,-size*2,0,0,-size*11/10,0);
    pyrsto[1]= new pLintu(-size/2,-size*2,0,0,-size*11/10,0);
    pyrsto[2]= new pLintu(0,-size*5/2,0,0,-size*11/10,0);
  }

  void Draw()
  {
    for(int i = 0;i< 14;i++)
    {
        vasen[i].paper();
        oikea[i].paper();  
    }
    
    for(int i = 0;i< 9;i++)
    {
        torso[i].paper();
    }
    for(int i = 0;i< 3;i++)
    { 
      pyrsto[i].paper();
    }
    for(int i = 0;i< 2;i++)
    {
      paa[i].paper();
    }
  
  }
  void Color(int time)
  {
    if(time >= 0)
    {
        vasen[14-time%15].changeColor(100);
        oikea[14-time%15].changeColor(100);
    }

      if (time > 13 && time <23)
      {
        torso[(time-14)%9].changeColor(100);
      }
      if (time > 21 && time < 25)
      {
      pyrsto[(time-22)%3].changeColor(100);
      }
      if (time >24 && time< 28)
      {
      paa[(time-25)%2].changeColor(100);
      }

  }
  void smallbirdmove(int value)
  {
       for(int i = 0;i< 14;i++)
    {
      vasen[i].move(value);
      oikea[i].move(value);
    }
    for(int i = 0;i< 9;i++)
      torso[i].move(value);
    for(int i = 0;i< 3;i++)
      pyrsto[i].move(value);
    for(int i = 0;i< 2;i++)
      paa[i].move(value);
  }
  void fly()
  {
     for(int i = 0;i< 14;i++)
    {
        vasen[i].paper();
        oikea[i].paper();  
    }
    
    for(int i = 0;i< 9;i++)
    {
        torso[i].paper();
    }
    for(int i = 0;i< 3;i++)
    { 
      pyrsto[i].paper();
    }
    for(int i = 0;i< 2;i++)
    {
      paa[i].paper();
    }
  
  
  }
  void smallbirdfly()
  {
   
       for(int i = 0;i< 14;i++)
    {
      vasen[i].fly();
      oikea[i].fly();
    }
    for(int i = 0;i< 9;i++)
      torso[i].fly();
    for(int i = 0;i< 3;i++)
      pyrsto[i].fly();
    for(int i = 0;i< 2;i++)
      paa[i].fly();
  
  }
  
  void fly1()
  {
    
    degree += fly;
     if (degree < -25) 
       fly = 1;
     if (degree > 25) 
       fly = -1;
     
     for(int i = 0;i< 14;i++)
    {
      vasen[i].setPosition(vasen[i].headX()-degree/3,vasen[i].headY()-degree/3,vasen[i].headZ(),vasen[i].tailX(),vasen[i].tailY(),vasen[i].tailZ());
      oikea[i].setPosition(oikea[i].headX()+degree/3,oikea[i].headY()-degree/3,oikea[i].headZ(),oikea[i].tailX(),oikea[i].tailY(),oikea[i].tailZ());
    }
  }
  
  
}

