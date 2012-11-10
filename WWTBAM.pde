import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import controlP5.*;

Minim minim;
AudioSample bigWin, lilWin, wrongAns;
AudioPlayer  easyQ, hardQ, player, finalAns;
ControlP5 cp5;
Textarea myTextarea,intro,answersEarned;
Button aButton,bButton,cButton,dButton,playButton;
Bang finalAnswer;
int difficulty;
Textlabel Atext;
int points = 0;
String lines[] = loadStrings("http://roast.hackerswagger.com/mill.txt");
String currentGuess;
int q = 0;
String guess;
String textValue = "";

void setup(){
  size(displayWidth,displayHeight);
//  size(600,400);
  background(0);
  noStroke();
  cp5 = new ControlP5(this);
    // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
  //player   = minim.loadFile("SE/easyquestion.mp3");
  bigWin   = minim.loadSample("SE/bigwin.mp3");
  lilWin   = minim.loadSample("SE/lilwin.mp3");
  easyQ    = minim.loadFile("SE/easyquestion.mp3"); 
  hardQ    = minim.loadFile("SE/hardquestion.mp3");
  finalAns = minim.loadFile("SE/finalanswer.mp3");
  wrongAns = minim.loadSample("SE/youlose.mp3");
  // play the file
  //player.play();
  playButton = cp5.addButton("Play")
               .setValue(0)
               .setPosition(5,height-2*(height/8)-10)
               .setSize(int(width/2-20),int(height/8))
               .setCaptionLabel("Let's play!")
               .setId(10)
               ;
  intro = cp5.addTextarea("Intro")
    .setText("Welcome to PhreakNIC")
    .setPosition(50,80)
    .setSize(600,200)
    .setFont(createFont("arial",48));
}
public void setupQuestions(){
  cp5.addTextfield("Question")
     .setPosition(width-40,5)
     .setSize(30,30)
     .setFont(createFont("arial",20))
     .setAutoClear(false)
     ;
     int answerFontSize = 48;
  myTextarea = cp5.addTextarea("theQuestion")
                  .setPosition(int(width/8),int(height/6))
                  .setSize(int(width-20),int(height-4*(height/8)))
                  .setFont(createFont("arial",answerFontSize))
                  .setLineHeight(answerFontSize)
                  .setColor(color(255))
                  .setColorBackground(color(0,100))
                  .setColorForeground(color(0,100));
                  ;
  answersEarned =  cp5.addTextarea("earned Answers")
                      .setPosition(5,height-3*(height/8)-10)
                      .setSize(500,100)
                      .setFont(createFont("arial",24))
                      .setLineHeight(20)
                      .setColor(color(255))
                      .setColorBackground(color(0,100))
                      .setColorForeground(color(0,100));
                      ;
  // create a new button with name 'buttonA'
  aButton = cp5.addButton(lines[q+2])
               .setValue(0)
               .setPosition(5,height-2*(height/8)-10)
               .setSize(int(width/2-20),int(height/8))
               .setId(1)
               ;
  bButton = cp5.addButton(lines[q+3])
               .setValue(0)
               .setPosition(5,height-height/8-5)
               .setSize(int(width/2-20),int(height/8))
               .setId(2)
               ;
  cButton = cp5.addButton(lines[q+4])
               .setValue(0)
               .setPosition(width-width/2,height-2*(height/8)-10)
               .setSize(int(width/2-20),int(height/8))
               .setId(3)
               ;
  dButton = cp5.addButton(lines[q+5])
               .setValue(0)
               .setPosition(width-width/2,height-height/8-5)
               .setSize(int(width/2-20),int(height/8))
               .setId(4)
               ;
  finalAnswer = cp5.addBang("Final Answer")
                   .setValue(0)
                   .setPosition(int(width/2-width/8),5)
                   .setSize(int(width/4),int(height/16))
                   .setTriggerEvent(Bang.RELEASE)
                   .setId(5)
               ;
}

void draw(){
  background(0);
}

public void updateAnswers(int index){
  myTextarea.setText(lines[index]);
  difficulty = int(lines[index+1]);
  if(difficulty == 0){
    easyQ.play();
  }
  else if(difficulty == 1){
    hardQ.play();
  }
  aButton.setCaptionLabel(lines[index+2]); 
  bButton.setCaptionLabel(lines[index+3]); 
  cButton.setCaptionLabel(lines[index+4]); 
  dButton.setCaptionLabel(lines[index+5]);
  answersEarned.setText(" "+points+" questions correct"); 
}

public void controlEvent(ControlEvent theEvent) {
  //print(theEvent);
  if(theEvent.isAssignableFrom(Textfield.class)){ 
    if( (int(theEvent.getStringValue())*7) <= lines.length){
      q = (int(theEvent.getStringValue())*7);
      if(hardQ.isPlaying())
        hardQ.pause();
      if(easyQ.isPlaying())
        easyQ.pause();
      updateAnswers(q);
    }
  }
  else if(theEvent.isAssignableFrom(Button.class)){
    print("button clicked id "+theEvent.getController().getId());
    switch(theEvent.getController().getId()){
      case(1): guess = "A"; finalAns.play(); currentGuess = "A"; break;
      case(2): guess = "B"; finalAns.play(); currentGuess = "B"; break;
      case(3): guess = "C"; finalAns.play(); currentGuess = "C"; break;
      case(4): guess = "D"; finalAns.play(); currentGuess = "D"; break;
      case(10):
        println("roooor");
        intro.hide();
        setupQuestions();
        updateAnswers(0);
      break;
      case(11): 
        check(currentGuess); 
      break;
    }
  }else{
    switch(theEvent.getController().getId()){
      case (5): check(currentGuess);break;
    }
  }
}

boolean check(String guess){
  println("check that guess "+guess+" equals "+lines[q+6]);
  
  if(guess.equals(lines[q+6])){
    //q = q+6;
    println("setting q to "+q);
    if(q == lines.length){
      //done
      player.pause();
    }else{
      updateAnswers(q);
    }
    if(difficulty == 0)
      lilWin.trigger();
    else if(difficulty == 1)
      bigWin.trigger();
    points++;
    return true;
  }
  else{
    wrongAns.trigger();
    return false;
  }
}

public void bang() {
  println(guess);
  check(guess);
}

