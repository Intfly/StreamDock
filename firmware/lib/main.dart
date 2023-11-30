import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StreamDock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const Action(),
    );
  }
}

class Action extends StatefulWidget {
  const Action({
    super.key,
  });

  @override
  State<Action> createState() => _Action();
}

const TextStyle styleTexte = TextStyle(fontSize: 25, fontWeight: FontWeight.w600);

class _Action extends State<Action> {
  bool afficheMenu = false;
  bool afficherArgument = false;
  int numTouche = 0;
  String actionChoisie = "0";
  String texteArgument = "";
  String argument = "";
  final fieldArg = TextEditingController();
  List<DropdownMenuItem> listeOptionsDrop = [DropdownMenuItem(value: "0", child: Text("défiler")), DropdownMenuItem(value: "1", child: Text("lancer un programme")), DropdownMenuItem(value: "2", child: Text("taper du texte")), DropdownMenuItem(value: "3", child: Text("ouvrir un lien"))];

  void actionBouton(int touche) {
    setState(() {
      if (numTouche == 0 || touche == numTouche || (touche != numTouche && !afficheMenu)) {
        afficheMenu = !afficheMenu;
      }
      numTouche = touche;
    });
  }

  ButtonStyle styleBoutonClavier = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color.fromARGB(115, 74, 74, 74),
      foregroundColor: const Color.fromARGB(255, 231, 230, 230));

  Widget boutonClavier(int touche) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: (() => actionBouton(touche)),
          style: styleBoutonClavier,
          child: SizedBox(
              width: 60,
              height: 90,
              child: Center(
                  child: Text(
                touche.toString(),
                style: const TextStyle(fontSize: 30),
              ))),
        ));
  }

  Widget boutonTouchesSysteme(String touche) {
    return Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10, top: 2),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              if (listeBoutonsUtilisee == listeBoutonsDefaut) {}
            });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: SizedBox(width: 70, height: 37, child: Center(child: Text(touche))),
        ));
  }

  Widget boutonTouchesRetour() {
    return TextButton(
        onPressed: () {
          setState(() {
            listeBoutonsUtilisee = listeBoutonsDefaut;
          });
        },
        child: const Icon(Icons.arrow_back_rounded));
  }

  late List<Widget> listeBoutonsDefaut = [boutonTouchesSysteme("windows"), boutonTouchesSysteme("frappe"), boutonTouchesSysteme("fonction"), boutonTouchesSysteme("LED"), boutonTouchesSysteme("autre")];
  late List<Widget> listeBoutonsUtilisee = listeBoutonsDefaut;

  late List<Widget> listeBoutonsWin = [boutonTouchesRetour(), boutonTouchesSysteme("shift"), boutonTouchesSysteme("ctrl"), boutonTouchesSysteme("alt"), boutonTouchesSysteme("windows")];
  late List<Widget> listeBoutonsFrappe = [boutonTouchesRetour(), boutonTouchesSysteme("tab"), boutonTouchesSysteme("backspace"), boutonTouchesSysteme("entrée"), boutonTouchesSysteme("espace")];
  late List<Widget> listeBoutonsFonction = [boutonTouchesRetour(), boutonTouchesSysteme("F21"), boutonTouchesSysteme("F22"), boutonTouchesSysteme("F23"), boutonTouchesSysteme("F24")];
  late List<Widget> listeBoutonsLED = [boutonTouchesRetour(), boutonTouchesSysteme("tab"), boutonTouchesSysteme("backspace"), boutonTouchesSysteme("entrée"), boutonTouchesSysteme("espace")];
  late List<Widget> listeBoutonsAutres = [boutonTouchesRetour(), boutonTouchesSysteme("tab"), boutonTouchesSysteme("backspace"), boutonTouchesSysteme("entrée"), boutonTouchesSysteme("espace")];

  void modifierFichierConfig() {
    try {
      final test = File('config.txt');
      test.readAsStringSync();
    } catch (e) {
      File('config.txt').create();
      final fichierConfig = File('config.txt');
      fichierConfig.writeAsStringSync("`1\$1\$NULL`2\$1\$NULL`3\$1\$NULL`4\$1\$NULL`5\$1\$NULL`6\$1\$NULL`7\$1\$NULL`8\$1\$NULL`");
    }
    //`1$1$NULL`2$1$NULL`3$1$NULL`4$1$NULL`5$1$NULL`6$1$NULL`7$1$NULL`8$1$NULL`
    final fichierConfig = File('config.txt');
    bool bonneLigne = false;
    int idxDbt = 0;
    int idxFin = 0;

    try {
      String contenu = fichierConfig.readAsStringSync();

      for (int i = 0; (i < contenu.length - 1) && !(bonneLigne && contenu[i] == "`"); i++) {
        if (contenu[i] != "\$") {
          if (contenu[i] == '`' && contenu[i + 1] == "$numTouche") {
            bonneLigne = true;
            idxDbt = i + 1;
          }
          if (bonneLigne) {
            if (contenu[i + 1] == "`") {
              idxFin = i;
            }
          }
        }
      }
      String config = "${contenu.substring(0, idxDbt)}$numTouche\$$actionChoisie\$$argument${contenu.substring(idxFin + 1, contenu.length)}";

      fichierConfig.writeAsStringSync(config);
    } catch (e) {
      print('erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: 1000,
          height: 720,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 679,
                    width: 73,
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 84, 92, 145)),
                    child: Column(children: [
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Action(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.keyboard_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "action",
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Lumiere(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.tips_and_updates_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "lumière",
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Mode(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.dark_mode_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "mode auto",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              )))
                    ]),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [boutonClavier(1), boutonClavier(2)],
                      ),
                      Row(
                        children: [boutonClavier(3), boutonClavier(4)],
                      ),
                      Row(
                        children: [boutonClavier(5), boutonClavier(6)],
                      ),
                      Row(
                        children: [boutonClavier(7), boutonClavier(8)],
                      )
                    ],
                  ),
                  afficheMenu
                      ? Container(
                          width: 600,
                          height: 679,
                          padding: const EdgeInsets.only(top: 100, left: 70),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text(
                              "action à réaliser:",
                              style: styleTexte,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButton(
                                items: listeOptionsDrop,
                                onChanged: (value) => {
                                      setState(() {
                                        actionChoisie = value!;
                                        afficherArgument = true;
                                        fieldArg.clear();
                                        argument = "";
                                        if (listeOptionsDrop.length == 4) {
                                          listeOptionsDrop.removeAt(0);
                                        }
                                        if (value == "1") {
                                          texteArgument = "path de l'executable";
                                        } else if (value == "2") {
                                          texteArgument = "touches à simuler";
                                        } else if (value == "3") {
                                          texteArgument = "lien internet";
                                        }
                                      })
                                    },
                                value: actionChoisie),
                            const SizedBox(
                              height: 30,
                            ),
                            afficherArgument
                                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(
                                      "$texteArgument:",
                                      style: styleTexte,
                                    ),
                                    SizedBox(
                                        width: 470,
                                        child: TextField(
                                          controller: fieldArg,
                                          onChanged: (value) {
                                            setState(() {
                                              argument = value;
                                            });
                                          },
                                          style: const TextStyle(fontSize: 17),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(15),
                                            border: OutlineInputBorder(
                                              gapPadding: 0,
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFF6F6F6),
                                            focusColor: const Color(0xFFF6F6F6),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "touches particulières:",
                                      style: styleTexte,
                                    ),
                                    Wrap(
                                      children: listeBoutonsUtilisee,
                                    )
                                  ])
                                : const SizedBox(),
                            (argument.isNotEmpty)
                                ? Container(
                                    padding: const EdgeInsets.only(top: 260, left: 250),
                                    child: ElevatedButton(
                                        onPressed: modifierFichierConfig,
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            backgroundColor: const Color.fromARGB(255, 84, 92, 145),
                                            foregroundColor: const Color(0xFFF6F6F6)),
                                        child: Container(
                                            padding: const EdgeInsets.only(top: 7),
                                            width: 180,
                                            height: 53,
                                            child: const Text(
                                              "appliquer",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 25),
                                            ))))
                                : const SizedBox()
                          ]))
                      : const SizedBox(
                          width: 600,
                          height: 679,
                        )
                ],
              )
            ],
          )),
    );
  }
}

class Lumiere extends StatefulWidget {
  const Lumiere({
    super.key,
  });

  @override
  State<Lumiere> createState() => _Lumiere();
}

class _Lumiere extends State<Lumiere> {
  Color couleur = Color.fromARGB(255, 216, 216, 216);

  void changementCouleur(Color nvCouleur) {
    couleur = nvCouleur;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: 1000,
          height: 720,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 679,
                    width: 73,
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 84, 92, 145)),
                    child: Column(children: [
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Action(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.keyboard_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "action",
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Lumiere(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.tips_and_updates_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "lumière",
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Mode(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.dark_mode_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "mode auto",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              )))
                    ]),
                  ),
                  SizedBox(
                      width: 850,
                      height: 650,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          const Text("Couleur des LEDs", style: TextStyle(fontSize: 37, fontWeight: FontWeight.w600)),
                          Center(
                            heightFactor: 2.2,
                            widthFactor: 2.8,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFfafdfd),
                                  boxShadow: List.filled(
                                    1,
                                    const BoxShadow(color: Color(0x25272727), spreadRadius: 5, blurRadius: 10),
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(25))),
                              child: SlidePicker(
                                pickerColor: couleur,
                                onColorChanged: changementCouleur,
                                colorModel: ColorModel.rgb,
                                enableAlpha: false,
                                displayThumbColor: true,
                                showParams: true,
                                showIndicator: true,
                                indicatorAlignmentBegin: const Alignment(-3.0, -3.0),
                                indicatorBorderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                              ),
                            ),
                            //TextField(onChanged: (nvCouleur) => couleur = Color(parse(nvCouleur)),) //rajouter entree manuelle de l'hex
                          )
                        ],
                      ))
                ],
              )
            ],
          )),
    );
  }
}

class Mode extends StatefulWidget {
  const Mode({
    super.key,
  });

  @override
  State<Mode> createState() => _Mode();
}

class _Mode extends State<Mode> {
  bool ctVSC = false;

  void modifierConfig(String logiciel) {
    try {
      final fichierConfig = File('configAuto.txt');
      String contenu = fichierConfig.readAsStringSync();

      for (int i = 0; i < contenu.length - 1; i++) {
        if (contenu[i] == "`") {
          if (contenu.substring(i + 1, i + 4) == logiciel) {
            if ((int.parse(contenu[i + 5]) % 2 == 1)) {
              fichierConfig.writeAsStringSync("${contenu.substring(0, i + 5)}0${contenu.substring(i + 6, contenu.length)}");
            } else {
              fichierConfig.writeAsStringSync("${contenu.substring(0, i + 5)}1${contenu.substring(i + 6, contenu.length)}");
            }
          }
        }
      }
    } catch (e) {
      print('erreur1: $e');
    }
    lireConfig();
  }

  void lireConfig() {
    try {
      // on le cree si ce n'est pas fait
      final test = File('configAuto.txt');
      test.readAsStringSync();
    } catch (e) {
      File('configAuto.txt').create();
      final fichierConfig = File('configAuto.txt');
      fichierConfig.writeAsStringSync("`VSC:0`");
    }
    final fichierConfig = File('configAuto.txt');
    try {
      String contenu = fichierConfig.readAsStringSync();

      for (int i = 0; i < contenu.length - 1; i++) {
        if (contenu[i] == "`") {
          if (contenu.substring(i + 1, i + 4) == "VSC") {
            setState(() {
              ctVSC = int.parse(contenu[i + 5]) % 2 == 1;
            });
          }
        }
      }
    } catch (e) {
      print('erreur2: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    lireConfig();
    return Scaffold(
      body: SizedBox(
          width: 1000,
          height: 720,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 679,
                    width: 73,
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 84, 92, 145)),
                    child: Column(children: [
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Action(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.keyboard_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "action",
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Lumiere(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.tips_and_updates_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "lumière",
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Mode(),
                                  ),
                                );
                              },
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.dark_mode_outlined,
                                    color: Color.fromARGB(255, 220, 220, 220),
                                  ),
                                  Text(
                                    "mode auto",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color.fromARGB(255, 220, 220, 220)),
                                  )
                                ],
                              )))
                    ]),
                  ),
                  Container(
                    width: 850,
                    height: 650,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          "Mode Auto",
                          style: TextStyle(fontSize: 37, fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          "le mode auto permet de basculer automatiquement le thème d'une application lorsque la luminosité ambiante est suffisament basse.",
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Visual Studio Code",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Switch(activeColor: const Color.fromARGB(255, 84, 92, 145), value: ctVSC, onChanged: ((value) => {modifierConfig("VSC")}))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
