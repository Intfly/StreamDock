#include <stdio.h>
#include <Windows.h>
#include <stdlib.h>
#include <string.h> //rend la manipulation des arguments plus facile
#include <winuser.h>
#include <time.h>


void lire_fichier_config(int pin);

clock_t cycles = clock();

//---------------------------------------------
//|                    MAIN                   |
//---------------------------------------------


//int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
int main(void){
    //cache la console
    clock_t cycles2 = clock();

    while (true) {
        cycles2 = clock();
        if ((unsigned long)clock() - cycles > 200) {//permet d'avoir un temps d'execution plus regulier qu'avec un sleep car on prends en compte le temps d'exec de la fonction précédente. Sert aussi à éviter la répétiion des frappes, problématique quand on met en pause la musique par exemple.
            if (GetAsyncKeyState(VK_F13) & 0x8000) {
                lire_fichier_config(49);
            }
            else if (GetAsyncKeyState(VK_F14) & 0x8000) {
                lire_fichier_config(50);
            }
            else if (GetAsyncKeyState(VK_F15) & 0x8000) {
                lire_fichier_config(51);
            }
            else if (GetAsyncKeyState(VK_F16) & 0x8000) {
                lire_fichier_config(52);
            }
            else if (GetAsyncKeyState(VK_F17) & 0x8000) {
                lire_fichier_config(53);
            }
            else if (GetAsyncKeyState(VK_F18) & 0x8000) {
                lire_fichier_config(54);
            }
            else if (GetAsyncKeyState(VK_F19) & 0x8000) {
                lire_fichier_config(55);
            }
            else if (GetAsyncKeyState(VK_F20) & 0x8000) {
                lire_fichier_config(56);
            }

        }
    }
    return 0;
}



//---------------------------------------------
//|                 ACTIONS                   |
//---------------------------------------------


//|-----------AUTOMATISATION FRAPPE-----------|

void appui_scrl() {
    for (int i = 0; i < 100; i++) {
        keybd_event(VK_SCROLL, 0x45, KEYEVENTF_EXTENDEDKEY | 0, 0);
        Sleep(100);
        keybd_event(VK_SCROLL, 0x45, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);
        Sleep(100);
        printf("%d", i);
    }
}

void appui_ctrl(bool appui) {//true : appui ; false: relachement
    INPUT input;
    input.type = INPUT_KEYBOARD;
    input.ki.wVk = VK_LCONTROL;
    input.ki.time = 0;
    input.ki.dwExtraInfo = 0;
    if (appui) {
        input.ki.dwFlags = 0;
    }
    else {
        input.ki.dwFlags = KEYEVENTF_KEYUP;
    }
    SendInput(1, &input, sizeof(INPUT));
}

void appui_touches(char caractere, char touche_systeme[]) {
    if (caractere != NULL) {//dans le cas d'un caratère simple
        WORD keyCode = VkKeyScanEx(caractere, GetKeyboardLayout(0));//par defaut, scan la touche et renvoi le keyCode propre aux claviers qwerty, il est different pour chaque disposision de clavier


        printf("char: %c keycode: %u   \n", caractere, keyCode);

        if (keyCode != 0) {
            INPUT input[2];//array d'input

            // appuie sur la touche
            input[0].type = INPUT_KEYBOARD;
            input[0].ki.wVk = keyCode;
            input[0].ki.dwFlags = 0;
            input[0].ki.time = 0;
            input[0].ki.dwExtraInfo = 0;
            bool shift = ((int)caractere >= 48 && (int)caractere <= 57) || ((int)caractere >= 65 && (int)caractere <= 90);

            if (shift) {//on verifie si le caractere necessite l'appui sur la touche SHIFT pour etre utilise. Auquel cas on appui sur la touche SHIFT 
                input[1].type = INPUT_KEYBOARD;
                input[1].ki.wVk = VK_SHIFT;
                input[1].ki.dwFlags = 0;
                SendInput(1, &input[1], sizeof(INPUT));
            }

            SendInput(1, &input[0], sizeof(INPUT));

            // relache la touche
            input[0].ki.dwFlags = KEYEVENTF_KEYUP;
            SendInput(1, &input[0], sizeof(INPUT));

            if (shift) {//on relache ensuite la touche SHIFT 
                input[1].ki.dwFlags = KEYEVENTF_KEYUP;
                SendInput(1, &input[1], sizeof(INPUT));
            }
        }
    }
    else {//pour les caractères spéciaux et touches systèmes: tabulation, entrée, supp, etc...
        /*
        documentation:
        https://docs.google.com/spreadsheets/d/1jvM6qGsZ-XtI66lRsnr6RroNsv_qWKXMQ_h3ri6RZ4g/edit?usp=sharing
        */
        
        INPUT input;
        input.type = INPUT_KEYBOARD;
        input.ki.dwFlags = 0;
        input.ki.time = 0;
        input.ki.dwExtraInfo = 0;
        if (touche_systeme[0] == 'T') {//input random(tab, espace, entree, effacer)
            if (touche_systeme[1] == 't') {
                input.ki.wVk = VK_TAB;
            }
            else if (touche_systeme[1] == 'e') {
                input.ki.wVk = VK_SPACE;
            }
            else if (touche_systeme[1] == 'r') {
                input.ki.wVk = VK_RETURN;
            }
            else if (touche_systeme[1] == 'b') {
                input.ki.wVk = VK_BACK;
            }
        }
        else if (touche_systeme[0] == 'S') {//touches systemes(shift, ctrl, alt, echap, windows, mise en veille)
            if (touche_systeme[1] == 's') {
                input.ki.wVk = VK_SHIFT;
            }
            else if (touche_systeme[1] == 'c') {
                input.ki.wVk = VK_CONTROL;
            }
            else if (touche_systeme[1] == 'a') {
                input.ki.wVk = VK_MENU;
            }
            else if (touche_systeme[1] == 'e') {
                input.ki.wVk = VK_ESCAPE;
            }
            else if (touche_systeme[1] == 'w') {
                input.ki.wVk = VK_LWIN;
            }
            else if (touche_systeme[1] == 'v') {
                input.ki.wVk = VK_SLEEP;//marche pas, possiblement executer commande qui sleep dans cmd
            }
        }
        else if (touche_systeme[0] == 'D') {//fleches directionnelles(haut bas gauche droite)
            if (touche_systeme[1] == 'g') {
                input.ki.wVk = VK_LEFT;
            }
            else if (touche_systeme[1] == 'd') {
                input.ki.wVk = VK_RIGHT;
            }
            else if (touche_systeme[1] == 'h') {
                input.ki.wVk = VK_UP;
            }
            else if (touche_systeme[1] == 'b') {
                input.ki.wVk = VK_DOWN;
            }
        }
        else if (touche_systeme[0] == 'F') {//touches fonction(f21 à f24) j'utilise déjà f13 à f20 inclus, loop infinie si je les rends dispo
            if (touche_systeme[1] == '1') {
                input.ki.wVk = VK_F21;
            }
            else if (touche_systeme[1] == '2') {
                input.ki.wVk = VK_F22;
            }
            else if (touche_systeme[1] == '3') {
                input.ki.wVk = VK_F23;
            }
            else if (touche_systeme[1] == '4') {
                input.ki.wVk = VK_F24;
            }
        }
        else if (touche_systeme[0] == 'L') {//LEDS(numLock, scrollLock, capsLock)
            if (touche_systeme[1] == 'n') {
                input.ki.wVk = VK_NUMLOCK;
            }
            else if (touche_systeme[1] == 's') {
                input.ki.wVk = VK_SCROLL;
            }
            else if (touche_systeme[1] == 'c') {
                input.ki.wVk = VK_CAPITAL;
            }
        }
        else if (touche_systeme[0] == 'C') {//Click gauche, droit et molette
            if (touche_systeme[1] == 'g') {
                input.ki.wVk = VK_LBUTTON;//marche pas
            }
            else if(touche_systeme[1] == 'd') {
                input.ki.wVk = VK_RBUTTON;//marche pas
            }
            else if (touche_systeme[1] == 'm') {
                input.ki.wVk = VK_MBUTTON;//marche pas
            }
        }
        
        else if (touche_systeme[0] == 'A') {//Autre (imprEcran, suppr, pageUp, fin, inserer, pageDown, pauseAttn)
            if (touche_systeme[1] == 'i') {
                input.ki.wVk = VK_SNAPSHOT;
            }
            else if (touche_systeme[1] == 's') {
                input.ki.wVk = VK_DELETE;
            }
            else if (touche_systeme[1] == 'u') {
                input.ki.wVk = VK_PRIOR;
            }
            else if (touche_systeme[1] == 'd') {
                input.ki.wVk = VK_NEXT;
            }
            else if (touche_systeme[1] == 'e') {
                input.ki.wVk = VK_END;
            }
            else if (touche_systeme[1] == 'n') {
                input.ki.wVk = VK_INSERT;
            }
            else if (touche_systeme[1] == 'h') {
                input.ki.wVk = VK_HOME;
            }
            else if (touche_systeme[1] == 'p') {
                input.ki.wVk = VK_PAUSE;
            }
        }
        else {
            printf("echec touche: %s \n", touche_systeme);
            return;
        }
        SendInput(1, &input, sizeof(INPUT));

        // relache la touche
        input.ki.dwFlags = KEYEVENTF_KEYUP;
        SendInput(1, &input, sizeof(INPUT));
    }
 
}
//|-----------LIEN INTERNET-----------|
void lien_internet(char url[]) {
    ShellExecuteA(NULL, "open", url, NULL, NULL, SW_SHOWNORMAL);
}

//|--------LANCEMENT PROGRAMME--------|
void lancer_programme(char path[]) {
    system(path);
}

//|-----------CONTROLE MEDIA-----------|
void controle_media(char argument[]) {
    INPUT input;
    input.type = INPUT_KEYBOARD;
    if (argument[0] == 'V') {//evite les comparaisons inutiles
        if (argument[1]=='+') {
            input.ki.wVk = VK_VOLUME_UP;
        }
        else if (argument[1] == '-') {
            input.ki.wVk = VK_VOLUME_DOWN;
        }
        else if (argument[1] == '0') {
        input.ki.wVk = VK_VOLUME_MUTE;
        }
    }
    else if (argument[0] == 'M') {
        if (argument[1] == '+') {
            input.ki.wVk = VK_MEDIA_NEXT_TRACK;
        }
        if (argument[1] == '-') {
            input.ki.wVk = VK_MEDIA_PREV_TRACK;
        }
    }
    else if (argument[0] == 'P') {
        input.ki.wVk = VK_MEDIA_PLAY_PAUSE;
    }
    input.ki.time = 0;
    input.ki.dwExtraInfo = 0;
    input.ki.dwFlags = 0;
    SendInput(1, &input, sizeof(INPUT));
    input.ki.dwFlags = KEYEVENTF_KEYUP;
    SendInput(1, &input, sizeof(INPUT));

}



void action_touche(char action, char argument[], char argument2[]) {
    if (action == '1') {
        lancer_programme(argument);
    }
    else if (action == '2') {
        char caractere_special[20]= "";
        bool ouvert = false;
        for (int i = 0; i <= strlen(argument)-1; i++) {
            if (ouvert && argument[i] != '~') {
                char temp[2] = { argument[i] };
                strcat_s(caractere_special, temp);
            }
            else if (argument[i] != '~') {
                appui_touches(argument[i], NULL);
            }
            else {
                ouvert = !ouvert;
                if (!ouvert) {
                    appui_touches(NULL, caractere_special);
                }
            }
        }
;    }
    else if (action == '3') {
        lien_internet(argument);
    }
    else if (action == '4') {
        controle_media(argument);
    }
}




//---------------------------------------------
//|                 CONFIG                    |
//---------------------------------------------

void lire_fichier_config(int pin) {
    cycles = clock();
    FILE* fichier_config;
    errno_t err;

    err = fopen_s(&fichier_config, "config.txt", "r");//ouvre le fichier de config en mode lecture uniquement
    int touche;
    bool nouvelle_ligne = false;
    bool bonne_ligne = false;
    char separateur_ligne = '`';//signe delimitant les differents pins
    char separateur_colonne = '$';
    char argument[256] = "";
    char argument2[256] = "";
    char action = '0';
    
    while ((touche = fgetc(fichier_config)) != EOF && !((char)touche == separateur_ligne && bonne_ligne)) {//on stoppe la lecture apres la lecture de la config du pin concerne.
        if ((char)touche != separateur_colonne) {//le separateur de colonne ne sert que dans la lecture du fichier de config brut
            if ((char)touche == separateur_ligne) {
                nouvelle_ligne = true;
            }
            else if (nouvelle_ligne && (char)touche == pin) {//pour s'assurer qu'il s'agit de la bonne ligne, on vérifie que le pin se situe apres le separateur de ligne et que le pin est le bon
                bonne_ligne = true;
                nouvelle_ligne = false;
            }
            else if (nouvelle_ligne) {
                nouvelle_ligne = false;
            }
            else if (bonne_ligne) {
                if (action == '0') {// on stocke l'action que devra realiser l'odinateur dans une variable
                    action = (char)touche;
                }
                else {
                    char temp[2] = { (char)touche };
                    strcat_s(argument, temp);
                }

            }
        }
        else if (strlen(argument)!=0) { //si on a plusieurs arguments
            strcpy_s(argument2, argument);
            strcpy_s(argument, "");
        }
    }
    fclose(fichier_config);


    //on interchange les variables des arguments 
    if (strlen(argument2) != 0) {
        char str_temp[256];
        strcpy_s(str_temp, argument);
        strcpy_s(argument, argument2);
        strcpy_s(argument2, str_temp);
    }

    action_touche(action, argument, argument2);
    
}