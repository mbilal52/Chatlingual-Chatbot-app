import 'dart:developer';
import 'package:chatgpt_app/constants/const.dart';
import 'package:chatgpt_app/providers/chats_provider.dart';
import 'package:chatgpt_app/providers/language_change_provider.dart';
import 'package:chatgpt_app/screens/loginScreen.dart';
import 'package:chatgpt_app/screens/navbar.dart';
import 'package:chatgpt_app/services/services.dart';
import 'package:chatgpt_app/widgets/chat_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../providers/models_provider.dart';
import '../widgets/text_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

enum Languages {english,urdu,sindhi}

class _ChatScreenState extends State<ChatScreen> {
  bool _isListening = false;
  bool _isTyping = false;

  final stt.SpeechToText _speech = stt.SpeechToText();
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
    _initializeSpeech();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
        setState(() {
          _isListening = status == stt.SpeechToText.withMethodChannel().isListening;
        });
      },
      onError: (errorNotification) {
        print('Speech recognition error: $errorNotification');
      },
    );

    if (!available) {
      print('Speech recognition not available');
    }
  }
    // Start/Stop speech recognition
    Future<void> _toggleListening() async {
      if (_isListening) {
        _speech.stop();
      } else {
        bool available = await _speech.initialize();
        if (available) {
          _speech.listen(
            onResult: (result) {
              setState(() {
                textEditingController.text = result.recognizedWords;
              });
            },
          );
        }
      }
      setState(() {
        _isListening =! _isListening;
      });
    }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 20,
        title: Text(
           AppLocalizations.of(context)!.chatlingual,//"helloworld".tr(),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25),
        ),
        toolbarHeight: 60,
        centerTitle: true,
        actions: [
          Consumer<LanguageChangeProvider>(builder: (context, provider, child){
            return PopupMenuButton(
                onSelected: (Languages item){
                  if(Languages.english.name == item.name){
                    provider.changeLanguage(Locale("en"));
                  }else if(Languages.urdu.name == item.name){
                    provider.changeLanguage(Locale("ur"));
                  }else{
                    provider.changeLanguage(Locale("sd"));
                  }
                },
                icon: Icon(Icons.language_outlined, color: Colors.white,),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Languages>>[
                  const PopupMenuItem(
                      value: Languages.english,
                      child: Text("English")),
                  const PopupMenuItem(
                      value: Languages.urdu,
                      child: Text("Urdu")),
                  const PopupMenuItem(
                      value: Languages.sindhi,
                      child: Text("Sindhi")),
                ]);
          })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatProvider
                          .getChatList[index].msg, // chatList[index].msg,
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                      shouldAnimate:
                          chatProvider.getChatList.length - 1 == index,
                    );
                  }),
            ),
            if (_isTyping) ...[
              LoadingAnimationWidget.waveDots(color: Colors.white, size: 30)
              // const SpinKitThreeBounce(
              //   color: Colors.white,
              //   size: 18,
              // ),
            ],
            const SizedBox(
              height: 10,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(
                                modelsProvider: modelsProvider,
                                chatProvider: chatProvider);
                          },
                          decoration: InputDecoration.collapsed(
                              hintText: AppLocalizations.of(context)!.how_can_I_help_you,
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                      onPressed: _toggleListening,
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
