import processing.serial.*;
import processing.net.*;
import java.io.*;
import controlP5.*;    
import static javax.swing.JOptionPane.*;

String Version = "Version: 1.0.1" + '\n' + "2021-03-16";

ControlP5 cp5;
CheckBox checkbox;

String fichier_Bitmap_Path;
String mode = "init";

//Serial
Serial mySerial;
String[] comList; 
int serial_Input = 0;

//Flags
boolean refresh = false;
boolean portSelect = false;
boolean is_Serial_Available = false;
boolean skipAVR = false;
boolean arduinoSelected = false;



void setup() {      
  size(490, 179); 
  background(0);
  initCp5();
}



void draw() {
  if (refresh) {
    Com();
    Droplist();
    refresh = false;
  }

  switch(mode) {

  case "init":                                               //Etat Initialisation
    //Attendre Évenement IU...
    background(0);
    break;

  case "avrdude":                                               //Etat Téléversement Arduino
    //Chemin d'Accès Avrdude
    String ArduinoPath = sketchPath() + "\\bin"; 
    int arduino = (int)cp5.get(DropdownList.class, "Choisir Arduino:").getValue();
    int comID = (int)cp5.get(DropdownList.class, "Choisir COM:").getValue();
    if (arduino == 0) { //Uno
      runCommand(new String[]{ArduinoPath+"/avr/bin/avrdude", "-P"+comList[comID - 1], "-C"+ArduinoPath+"/avr/etc/avrdude.conf", "-patmega328p", "-carduino", "-v", "-V", "-D", "-b115200", "-Uflash:w:"+sketchPath()+"\\bin\\FPGA_prog.hex"+":i"});
      mode = "Check_Path";
    } else if (arduino == 1) { // Maker 1010 wifi
      //À faire (SAMD PROCESSOR BASE) not AVR
      exit();
    } else if (arduino == 2) { // Nano
      runCommand(new String[]{ArduinoPath+"/avr/bin/avrdude", "-P"+comList[comID - 1], "-C"+ArduinoPath+"/avr/etc/avrdude.conf", "-pm328p", "-carduino", "-v", "-V", "-D", "-b57600", "-Uflash:w:"+sketchPath()+"\\bin\\FPGA_prog_Nano.hex"+":i"});
      mode = "Check_Path";
    }
    break;

  case "Check_Path":
    if (fichier_Bitmap_Path == null) {
      showMessageDialog(null, "Aucun Fichier Bitmap Selectionné", "Erreur", ERROR_MESSAGE);
      mode = "init";
    } else {
      mode = "FPGA_Prog";
    }
    break;

  case "FPGA_Prog":     //État Programmation FPGA
    comID = (int)cp5.get(DropdownList.class, "Choisir COM:").getValue();
    byte[] FPGA_data = loadBytes(fichier_Bitmap_Path);
    mySerial = new Serial(this, comList[comID - 1], 115200);
    delay(3000);
    System.out.println(FPGA_data.length);
    FPGA_data = format_Array_64(FPGA_data, FPGA_data.length);

    String error = sendCommand('r');
    if (check_error(error)) break;
    int u = 0;
    System.out.println("Reset Send to arduino");
    byte data[] = new byte[64];
    for (int i = 0; i < ceil(FPGA_data.length /64); i++) {
      arrayCopy(FPGA_data, u, data, 0, 64);
      u = ((i + 1)   * 64) - 1;
      error = sendBlock(data);
      if (check_error(error)) break;
      is_Serial_Available = false;
      serial_Input = 0;
    } 

    mode = "end"; 
    break;

  case "end":
    System.out.println("Done");   
    exit();
    break;

  case "bug":
    System.out.println("An error as occured");
    mode = "init";
    break;
  }
}

boolean check_error(String error) {
  if (error != null) {
    System.out.println(error);
    showMessageDialog(null, error, "Erreur", ERROR_MESSAGE);
    mode = "bug";
    return true;
  } else {
    return false;
  }
}

/*********************************
*Gestion Event Choisir Fichier
**********************************/
void BitmapSelected(File selection) {
  if (selection == null) {
    System.out.println("No files Selected");

    int pane = showConfirmDialog(null, "No file were selected"+ '\n' +"Do you want to proceed?", "Erreur", WARNING_MESSAGE, OK_CANCEL_OPTION);
    if (pane == 2) {
      selectInput("Selectioner fichier bitmap (.bin)", "BitmapSelected");
    }
  } else {

    String file_path = selection.getAbsolutePath();
    System.out.println(file_path.substring(file_path.length() - 3));
    if (file_path.substring(file_path.length() - 3).equals("bin")  == true) {
      fichier_Bitmap_Path = selection.getAbsolutePath();
    } else {
      showMessageDialog(null, "Le fichier selectionner n'est pas un fichier .bin", "Erreur", ERROR_MESSAGE);
      selectInput("Selectioner fichier bitmap (.bin)", "BitmapSelected");
    }
  }
}

/*****************************************
*Fonction Pour Programation FPGA
******************************************/

String readReponse() {
  int ACK = 6;
  int NAK = 21;
  long temps_ecoule = millis();
  while (!is_Serial_Available) {
    if (millis() - temps_ecoule > 1000) {
      return "timeout";
    }
  }
  int Reponse = serial_Input;
  if (Reponse == ACK) return null;
  else if (Reponse == NAK) return "lecture Invalide";
  else if (Reponse == 0) return "timeout";
  else return "Status Inconnu";
}

String sendCommand(char command) {
  mySerial.write(command);
  delay(2000);
  return readReponse();
}

String sendBlock(byte[] data) {
  mySerial.write('b');
  for (int j = 0; j < 64; j++) {
    mySerial.write(data[j]);
  }
  return readReponse();
}

byte [] format_Array_64(byte [] data_non_formate, int nb_of_elements) {

  int a = 0;
  if ((nb_of_elements) % 64 > 0) {
    a = (64 - (nb_of_elements) % 64);
  } else {
    a = 0;
  }
  byte [] data_formate = new byte[nb_of_elements + a + 64];
  System.out.println(data_formate.length);
  System.out.println(a);
  arrayCopy(data_non_formate, 0, data_formate, 0, nb_of_elements);

  return data_formate;
}

/******************************
/*Gestion Interface D'utilisateur
/******************************/

void initCp5() {
  cp5 = new ControlP5(this);
  PFont theFont = createFont("Calibri", 15);


  checkbox = cp5.addCheckBox("checkboxes")  
    .setValue(0)
    .setPosition(285, 10)
    .setSize(15, 15)
    .setId(6)
    .addItem("Skip_arduino_prog", 0)
    .setFont(theFont);

  cp5.addButton("Choisir Fichier Bitmap")
    .setValue(0)
    .setPosition(10, 150)
    .setSize(230, 19)
    .setId(4)
    .setFont(theFont);

  cp5.addButton("Lancer Programation")
    .setValue(0)
    .setPosition(250, 150)
    .setSize(230, 19)
    .setId(3)
    .setFont(theFont);

  cp5.addButton("...")
    .setValue(0)
    .setPosition(270, 10)
    .setSize(15, 15)
    .setId(7)
    .setFont(theFont)
    .setColorBackground(color(60))
    .setColorActive(color(255, 128));


  DropdownList arduino = cp5.addDropdownList("Choisir Arduino:")
    .setPosition(135, 10)
    .setId(2)
    .setFont(theFont)
    .setSize(135, 100)
    .setItemHeight(15)
    .setBarHeight(15)
    .setColorBackground(color(60))
    .setColorActive(color(255, 128))
    .addItem("Uno", 0)
    .addItem("Maker Ind", 1)
    .addItem("Nano", 2);
  arduino.getCaptionLabel().getStyle().setMargin(4, 0, 0, 0);
  arduino.getValueLabel().getStyle().setMargin(4, 0, 0, 0);

  Com();

  Droplist();
}


void Com() {
    PFont theFont = createFont("Calibri", 15);
    DropdownList COM_list = cp5.addDropdownList("Choisir COM:")
    .setPosition(10, 10)
    .setId(1)
    .setFont(theFont)
    .setSize(125, 150)
    .setItemHeight(15)
    .setBarHeight(15)
    .setColorBackground(color(60))
    .setColorActive(color(255, 128, 0));

  COM_list.getCaptionLabel().getStyle().setMargin(4, 0, 0, 0); 
  COM_list.getValueLabel().getStyle().setMargin(4, 0, 0, 0);
}

void Droplist() {
  cp5.get(DropdownList.class, "Choisir COM:").addItem("Rafraîchir Com", 0);   
  if (Serial.list().length != 0) {
    comList = Serial.list();
    //We need to know how many mySerials there are, to know how many items to add to the list, so we will convert it to a String object (part of a class).
    String comlist = join(comList, ",");
    //We also need how many characters there is in a single mySerial name, we´ll store the chars here for counting later.
    String COMlist = comList[0];
    //Here we count the length of each mySerial name.
    int size2 = COMlist.length();
    //Now we can count how many mySerials there are, well that is count how many chars there are, so we will divide by the amount of chars per mySerial name.
    int size1 = comlist.length() / size2;
    //Now well add the mySerials to the list, we use a for loop for that. How many items is determined by the value of size1. 
    for (int i=0; i< size1; i++)
    {
      //This is the line doing the actual adding of items, we use the current loop we are in to determin what place in the char array to access and what item number to add it as.
      cp5.get(DropdownList.class, "Choisir COM:").addItem(comList[i], i + 1);
    }
  } else {
    showMessageDialog(null, "Aucun COM disponible", "Erreur", ERROR_MESSAGE);
    mode = "bug";
  }
}

/************************************
*Programmation AVR
*************************************/

void runCommand(String[] cmd) {

  String s = null;

  try {

    Process p = Runtime.getRuntime().exec(cmd);   

    BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
    BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

    // read the output from the command      
    System.out.println("command out:\n"); 
    while ( (s = stdInput.readLine ()) != null) System.out.println(s);     
    System.out.println("errors (if any):\n");      
    while ( (s = stdError.readLine ()) != null) System.out.println(s);
    p.destroy();
  }

  catch (IOException e) {      
    System.out.println("something went wrong: \n");      
    e.printStackTrace();
  }
}



void controlEvent(ControlEvent theEvent) {

  if (theEvent.isFrom(checkbox)) {
    skipAVR = checkbox.getState(0);
  } else {

    switch(theEvent.getId()) {

      case(1):
      int comID = (int)(theEvent.getController().getValue());
      if (comID == 0) {
        refresh = true;
      } else {
        portSelect = true;
      }
      break;

      case(2):
      arduinoSelected = true;
      break;

      case(3):
      if (portSelect && arduinoSelected) mode = "avrdude";
      else showMessageDialog(null, "Veuillez sélectionner un port et un modèle d'aruino", "Erreur", ERROR_MESSAGE);
      if (skipAVR) {
        int pane = showConfirmDialog(null, "La programation de l'arduino va être ignorée"+ '\n' +"Continuer?", "Avertissement", WARNING_MESSAGE, OK_CANCEL_OPTION);
        if (pane == 2) {
          mode = "init";
        } else {
          mode = "Check_Path";
        }
      }
      break;

      case(4):
      selectInput("Selectioner fichier bitmap (.bin)", "BitmapSelected"); 
      break;

      case(7):
      showMessageDialog(null, Version + '\n' + "Programmeur ICE40 par Arduino (Nano et Uno) (reset pin 7)", "Information", PLAIN_MESSAGE);
      break;
    }
  }
}



void serialEvent (Serial mySerial) { 
  serial_Input = mySerial.read();
  is_Serial_Available = true;
}
