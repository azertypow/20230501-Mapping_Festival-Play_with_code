import themidibus.*; //Import the library
MidiBus myBus; // The MidiBus 
 

void setupmidi(){
  myBus = new MidiBus(this, 1, 0);
  MidiBus.list(); // List all devices
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  
  //NOVATION XL
  //Scenes from 1 to n
    if(pitch==41 && velocity==127)mode=1;
    if(pitch==42 && velocity==127)mode=2;
    if(pitch==43 && velocity==127)mode=3;
    if(pitch==44 && velocity==127)mode=4;
    if(pitch==57 && velocity==127)mode=5;
    if(pitch==58 && velocity==127)mode=6;
    if(pitch==59 && velocity==127)mode=7;
    if(pitch==60 && velocity==127)mode=8;
    if(pitch==73 && velocity==127)mode=9;
    if(pitch==74 && velocity==127)mode=10;
    if(pitch==75 && velocity==127)mode=11;
    if(pitch==76 && velocity==127)mode=12;
    //if(number==16){
    //  //backMode1=map(value,0,128,0,255);
    //}
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  
  
 
  
 /*UC33
   if(number==16 && value==127){
    mode--;
    //if(mode==1)mode=12;  
  }
  
  if(number==17 && value==127){
    mode++;
    //if(mode==12)mode=1;
  }
   
    //Potards
    if(number==10 && channel==0){
      amount = map(value,0,127,1.1,20);
      if(mode==2)amount = map(value,0,127,1.1,10);
      if(mode==6)amount = map(value,0,127,10,20);
    }
    if(number==10 && channel==1){
      channelIntensity = map(value,0,127,0.1,8);
      if(mode==5) channelIntensity = map(value,0,127,0,8);
  
    }
    if(number==10 && channel==2){
      size = map(value, 0,127,1,100);
      if(mode==5)size = map (value,0,127,100,500);
    }
    if(number==10 && channel==3){
      sinPower = map(value,0,127,100,8000);
      if(mode==2|mode==3)sinPower = map(value,0,127,100,2700);
      if(mode==4){
        sinPower = map(value,0,127,0,100);
        cosPower = sinPower;
        
  
      }
    }
    if(number==10 && channel==4){
      tanPower = map(value,0,127,100,8000);
    }
    //if(number==21){
    //}
    //if(number==22){
    //}
    //if(number==23){
    //}
    
    //Sliders
    if(channel==0 && number==7){
      bgPower = map(value,0,127,0.1,4);
    }
    if(channel==1 && number==7){
      x = map(value,0,127,0,width);
      if(mode==5)x = map(value,0,127,0,width);    
    }
    if(channel==2 && number==7){
      y = map(value,0,127,0,height);
      if(mode==5)y = map(value,0,127,0,height);    
  
    }
    if(channel==3 && number==7){
      z = map(value,0,127,0,2000);
  
    }
    if(number==4){
    }
    if(number==5){
    }
    if(number==6){
    }
    if(number==7){
    }
    if(number==8){
    }
    
    //R Buttons -> Scenes from 1 to n
    if(number==19)mode=1;
    if(number==20)mode=2;
    if(number==21)mode=3;
    if(number==22)mode=4;
    if(number==23)mode=5;
    if(number==24)mode=6;
    if(number==25)mode=7;
    if(number==26)mode=8;
    if(number==27)mode=9;
    //if(number==28)mode=10;
    //if(number==29)mode=11;
    //if(number==51)mode=12;
    //if(number==16){
    //  //backMode1=map(value,0,128,0,255);
    //}
*/
    //NOVATION LAUNCHCONTROL XL 
    if(number==106 && value==127){
    mode--;
    //if(mode==1)mode=12;  
    }
    
    if(number==107 && value==127){
      mode++;
      //if(mode==12)mode=1;
    }
    
    //Potards
    if(number==49 && channel==8){
      amount = map(value,0,127,1.1,20);
      if(mode==2)amount = map(value,0,127,1.1,10);
      if(mode==6)amount = map(value,0,127,10,20);
    }
    if(number==50 && channel==8){
      channelIntensity = map(value,0,127,0.1,8);
      if(mode==5) channelIntensity = map(value,0,127,0,8);
  
    }
    if(number==51 && channel==8){
      size = map(value, 0,127,1,100);
      if(mode==5)size = map (value,0,127,100,500);
    }
    if(number==52 && channel==8){
      sinPower = map(value,0,127,100,8000);
      if(mode==2|mode==3)sinPower = map(value,0,127,100,2700);
      if(mode==4){
        sinPower = map(value,0,127,0,100);
        cosPower = sinPower;
        
  
      }
    }
    if(number==53 && channel==8){
      tanPower = map(value,0,127,100,8000);
    }
    //if(number==21){
    //}
    //if(number==22){
    //}
    //if(number==23){
    //}
    
    //Sliders
    if(channel==8 && number==77){
      bgPower = map(value,0,127,0.1,4);
    }
    if(channel==8 && number==78){
      x = map(value,0,127,0,width);
      if(mode==5)x = map(value,0,127,0,width);    
    }
    if(channel==8 && number==79){
      y = map(value,0,127,0,height);
      if(mode==5)y = map(value,0,127,0,height);    
  
    }
    if(channel==8 && number==80){
      z = map(value,0,127,0,2000);
  
    }
    if(number==4){
    }
    if(number==5){
    }
    if(number==6){
    }
    if(number==7){
    }
    if(number==8){
    }
    
    
}
