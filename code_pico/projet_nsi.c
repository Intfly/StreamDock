#include <stdlib.h>
#include <string.h>

#include "usb_descriptors.h"
#include "bsp/board.h"
#include "tusb.h"
#include "hardware/gpio.h"


//pins envoyant du courant aux touches
const uint PWR1 = 3; 
const uint PWR2 = 7;

//pins recevant le courant
const uint R1 = 11;
const uint R2 = 13;
const uint R3 = 18;
const uint R4 = 21;

//pins LED
const uint L1 = 22;
const uint L2 = 26;
const uint L3 = 28;

int y = 0;
int touche;
#define LED_PIN PICO_DEFAULT_LED_PIN

void clavier(void); //declaration explicite de la fonction pour le compilateur
void led(void);

int main() {
    board_init();
    tusb_init();


    //pins LED
    gpio_init(L1);
    gpio_init(L2);
    gpio_init(L3);

    //pins clavier
    gpio_init(PWR1);
    gpio_set_dir(PWR1, GPIO_OUT);
    gpio_init(PWR2);
    gpio_set_dir(PWR2, GPIO_OUT);
    gpio_init(R1);
    gpio_set_dir(R1, GPIO_IN);
    gpio_init(R2);
    gpio_set_dir(R2, GPIO_IN);
    gpio_init(R3);
    gpio_set_dir(R3, GPIO_IN);
    gpio_init(R4);
    gpio_set_dir(R4, GPIO_IN);

    //pin LED board
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);


    while(true){
        tud_task();
        clavier();
        led();
    }

    return 0;
}

void activer_bouton_led(uint bouton){
    gpio_set_dir(bouton, GPIO_OUT);
    gpio_put(bouton,1);
    sleep_ms(50);
    gpio_put(bouton,0);
}

void led(){

}


static void send_hid_report(uint8_t report_id, uint32_t btn){

    // skip if hid is not ready yet
    if (!tud_hid_ready()) return;

    //
    static bool touche_enfoncee = false;

    if (btn){
      uint8_t keycode[6] = {0};//paquet de 6 char max, la norme pour un transfert usb conventionnel
      keycode[0] = touche;

    tud_hid_keyboard_report(REPORT_ID_KEYBOARD, 0, keycode);
    touche_enfoncee = true;
    }
    else{
      // envoi d'un paquet vide si une touche etait appuyee
      if (touche_enfoncee) tud_hid_keyboard_report(REPORT_ID_KEYBOARD, 0, NULL);
      touche_enfoncee = false;
    }  
}

int recuperer_touche(){
    //on utilise algorithme de scan de matrice afin de detecter si une touche est pressee.
    gpio_put(PWR1,1);
    sleep_ms(5);
    int etatR1 = gpio_get(R1);
    int etatR2 = gpio_get(R2);
    int etatR3 = gpio_get(R3);
    int etatR4 = gpio_get(R4);
    gpio_put(PWR1,0);
    if(etatR1){
        touche=HID_KEY_F14;
    }
    else if(etatR2){
        touche=HID_KEY_F16;
    }
    else if(etatR3){
        touche=HID_KEY_F18;
    }
    else if(etatR4){
        touche=HID_KEY_F20;
    }
    if(etatR2 || etatR1 || etatR3 || etatR4){
        return 1;
    }
    

    gpio_put(PWR2,1);
    sleep_ms(5);
    etatR1 = gpio_get(R1);
    etatR2 = gpio_get(R2);
    etatR3 = gpio_get(R3);
    etatR4 = gpio_get(R4);
    gpio_put(PWR2,0);
    if(etatR1){
        touche=HID_KEY_F13;
    }
    else if(etatR2){
        touche=HID_KEY_F15;
    }
    else if(etatR3){
        touche=HID_KEY_F17;
    }
    else if(etatR4){
        touche=HID_KEY_F19;
    }
    if(etatR1 || etatR2 || etatR3 || etatR4){
        return 1;
    }

    return 0;
}


void clavier(){
    int temps_borne_ms = 0;
    int temps_ecoule_ms = board_millis();
    if(temps_ecoule_ms < 10+temps_borne_ms) return; //on veut push les touches 100 fois par seconde, s'il est trop tot, l'execution de la fonction n'est pas poursuivi
    temps_ecoule_ms = temps_ecoule_ms + 10;
    
    // btn = board_button_read();
    uint32_t const btn = recuperer_touche();
    if (tud_suspended() && btn){ //relance les pulls de l'ordinateur
    tud_remote_wakeup();
    }
    else{
      send_hid_report(REPORT_ID_KEYBOARD, btn);
    }

}




void tud_hid_report_complete_cb(uint8_t instance, uint8_t const* report, uint16_t len)
{
  (void) instance;
  (void) len;

  uint8_t next_report_id = report[0] + 1;

  if (next_report_id < REPORT_ID_COUNT)
  {
    send_hid_report(next_report_id, board_button_read());
  }
  
}





void tud_hid_set_report_cb(uint8_t instance, uint8_t report_id, hid_report_type_t report_type, uint8_t const* buffer, uint16_t bufsize){
    uint8_t const kbd_leds = buffer[0];
    if(kbd_leds & KEYBOARD_LED_SCROLLLOCK & KEYBOARD_LED_CAPSLOCK & KEYBOARD_LED_NUMLOCK){
        activer_bouton_led(L2);
    }
    else if(kbd_leds & KEYBOARD_LED_SCROLLLOCK & KEYBOARD_LED_CAPSLOCK){
        activer_bouton_led(L1);
    }
    else if(kbd_leds & KEYBOARD_LED_SCROLLLOCK){
        activer_bouton_led(L3);
    }
        
}



//fonction inutile mais necessaire, si elle n'est pas mise cela engendre une erreur lors du build.
uint16_t tud_hid_get_report_cb(uint8_t instance, uint8_t report_id, hid_report_type_t report_type, uint8_t* buffer, uint16_t reqlen){
  return 0;
}




