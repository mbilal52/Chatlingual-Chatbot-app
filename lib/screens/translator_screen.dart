

import 'package:chatgpt_app/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  List<String> languages = [
    'English',
    'Sindhi',
    'Urdu',
    'Hindi',
    'Arabic	',
    'German',
    'Russian',
    'Spanish',
    'Japanese	',
    'Italian',
  ];
  List<String> languagescode = [
    'en',
    'sd',
    'ur',
    'hi',
    'ar',
    'de',
    'ru',
    'es',
    'ja',
    'it',
  ];
  final translator = GoogleTranslator();
  String from = 'en';
  String to = 'ur';
  String data = 'آپ کیسے ہو';
  String selectedvalue = 'English';
  String selectedvalue2 = 'Urdu';
  TextEditingController controller =
  TextEditingController(text: 'How are you?');
  final formkey = GlobalKey<FormState>();
  bool isloading = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  translate() async {
    try {
      if (formkey.currentState!.validate()) {
        await translator
            .translate(controller.text, from: from, to: to)
            .then((value) {
          data = value.text;
          isloading = false;
          setState(() {});
          print(value);
        });
      }
    } on SocketException catch (_) {
      isloading = true;
      SnackBar mysnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    // translate();
    _initializeSpeech();
  }

  void _initializeSpeech(){
    _speech.initialize(
      onError: (error) => print("Error $error"),
      onStatus: (status) => print("Status $status")
    );
  }

  String selectedVoiceLanguage = 'en-US';

  void _startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
          controller.text = _text;
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
              color: scaffoldBackgroundColor,
            )),
        automaticallyImplyLeading: false,
        title: const Text(
          'Translator',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      backgroundColor: cardColor,
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('From', style: TextStyle(fontSize: 15),),
                    const SizedBox(
                      width: 100,
                    ),
                    DropdownButton(
                      value: selectedvalue,
                      focusColor: Colors.transparent,
                      items: languages.map((lang) {
                        return DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                          onTap: () {
                            if (lang == languages[0]) {
                              from = languagescode[0];
                            } else if (lang == languages[1]) {
                              from = languagescode[1];
                            } else if (lang == languages[2]) {
                              from = languagescode[2];
                            } else if (lang == languages[3]) {
                              from = languagescode[3];
                            } else if (lang == languages[4]) {
                              from = languagescode[4];
                            } else if (lang == languages[5]) {
                              from = languagescode[5];
                            } else if (lang == languages[6]) {
                              from = languagescode[6];
                            } else if (lang == languages[7]) {
                              from = languagescode[7];
                            } else if (lang == languages[8]) {
                              from = languagescode[8];
                            } else if(lang == languages[9]){
                              from = languagescode[9];
                            }
                            setState(() {
                              // print(lang);
                              // print(from);
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedvalue = value!;
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black)),
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    controller: controller,
                    maxLines: null,
                    minLines: null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    decoration:  InputDecoration(
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        errorStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                            onPressed: (){
                              if(_isListening){
                                _stopListening();
                              } else{
                                _startListening();
                              }
                            },
                            icon: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: Colors.white,
                            )
                        )
                    ),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    // initialValue: controller.text.isEmpty ? _text : null,
                    onChanged: (value){
                      _text = value;
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('To', style: TextStyle(fontSize: 15),),
                    const SizedBox(
                      width: 100,
                    ),
                    DropdownButton(
                      value: selectedvalue2,
                      focusColor: Colors.transparent,
                      items: languages.map((lang) {
                        return DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                          onTap: () {
                            if (lang == languages[0]) {
                              to = languagescode[0];
                            } else if (lang == languages[1]) {
                              to = languagescode[1];
                            } else if (lang == languages[2]) {
                              to = languagescode[2];
                            } else if (lang == languages[3]) {
                              to = languagescode[3];
                            } else if (lang == languages[4]) {
                              to = languagescode[4];
                            } else if (lang == languages[5]) {
                              to = languagescode[5];
                            } else if (lang == languages[6]) {
                              to = languagescode[6];
                            } else if (lang == languages[7]) {
                              to = languagescode[7];
                            } else if (lang == languages[8]) {
                              to = languagescode[8];
                            } else if (lang == languages[9]) {
                              to = languagescode[9];
                            }
                            setState(() {
                              print(lang);
                              print(from);
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedvalue2 = value!;
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black)),
                child: Center(
                  child: SelectableText(
                    data,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: translate,
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.indigo.shade100),
                      fixedSize: const MaterialStatePropertyAll(Size(300, 45))),
                  child:isloading?const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(color: Colors.white,),
                  ): const Text('Translate', style: TextStyle(color: Colors.black),)),
              const SizedBox(
                height: 30,
              )
            ],
          )),
    );
  }
}
