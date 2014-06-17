import java.util.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class AudioManager{
  PApplet applet;
  
  Minim minim;
  AudioPlayer audioplayer; // soittaa musat, doh
  MultiChannelBuffer buffers; // sama biisi bufferissa kerrallaan
  float[] sampledata; // bufferin samplet raakana
  FFT fft;
  
  int bufsize; // soittopuskurin koko
  int windowsize; // fft-puskurin koko
  int rate; // samplerate
  
  BeatDetect bdetect;

  AudioManager(PApplet _applet, String songName, int _bufsize, int _windowsize){
    applet = _applet;
    bufsize = _bufsize;
    windowsize = _windowsize;
     
    minim = new Minim(applet);    
    audioplayer = minim.loadFile(songName, bufsize);
    buffers = new MultiChannelBuffer(2, 2); // initnumeroilla ei vÃ¤liÃ¤
    
    rate = (int)audioplayer.sampleRate();
    minim.loadFileIntoBuffer(songName, buffers);
    sampledata = buffers.getChannel(0); // vain vasen kanava
    fft = new FFT(windowsize, rate);
    fft.window(FFT.HAMMING); 
    
    bdetect = new BeatDetect(windowsize, rate);
    bdetect.detectMode(BeatDetect.FREQ_ENERGY);
  
  }

  float currentTimeSeconds(){  
     return audioplayer.position() / 1000.0; 
  }

  void play(){
      audioplayer.play();  
  }
  
  void pause(){
     audioplayer.pause(); 
  }
  
  boolean isPlaying(){
     return audioplayer.isPlaying();
  }
  
  void update(){
    analyze();
  }  
  
  float analyzeRange(int f_a, int f_b){
    float fftsum = 0;
    for(int i = f_a; i <= f_b; i++){
      fftsum += fft.getBand(i);      
    }
    return fftsum / (f_b - f_a +1.0); //linearize
   }
  
  BeatDetect beatDetector(){
     return bdetect; 
  }
  
  
  //must be called in draw
  void analyze() {
    int samplepos = player_samplepos();
    float[] window = Arrays.copyOfRange(sampledata, samplepos, samplepos + windowsize);
    fft.forward(window);
    bdetect.detect(window);
  }
  
  // mistÃ¤ kohdasta luetaan fft-sampleikkuna
  int player_samplepos() {
    // minim palauttaa millisekunteja
    float secs = audioplayer.position() / 1000.0;
    // aika sampleyksikÃ¶issÃ¤
    int samplepos = (int)(secs * audioplayer.sampleRate());
    // nykyhetki ikkunan keskelle, vaihtoehtona mm.
    // koko windowsize eli aika ikkunan lopussa 
    samplepos -= windowsize/2;
    // ei vahingossakaan negatiiviseks
    samplepos = max(samplepos, 0);
    // eikÃ¤ toisenkaan reunan yli
    samplepos = min(samplepos, sampledata.length - windowsize);
    return samplepos;
  }
  
  void skip(int milliseconds){
     audioplayer.skip(milliseconds); 
  } 


}
