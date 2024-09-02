
import 'package:chatgpt_app/constants/const.dart';
import 'package:chatgpt_app/screens/loginScreen.dart';
import 'package:chatgpt_app/screens/text_to_image_Screen.dart';
import 'package:chatgpt_app/screens/translator_screen.dart';
import 'package:chatgpt_app/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {


  DatabaseReference ref = FirebaseDatabase.instance.ref("users");

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cardColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }else{
                      return Text(snapshot.data!.snapshot.child("username").value.toString(),style: TextStyle(fontSize: 20),);
                    }
                  }),
              accountEmail: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }else{
                      return Text(snapshot.data!.snapshot.child("email").value.toString());
                    }
                  }),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('assets/images/aiblack.png',
                scale: 5,),),
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.4)
            ),
          ),
          ListTile(
            leading: Icon(Icons.chat,color: Colors.white,),
            title: Text(AppLocalizations.of(context)!.models, style: TextStyle(color: Colors.white),),
            onTap: (){
              Services.showModalSheet(context: context);
            },
          ),
          ListTile(
            leading: Icon(Icons.translate, color: Colors.white,),
            title: Text("Translator", style: TextStyle(color: Colors.white),),
            onTap: (){
              Navigator.push(context, (MaterialPageRoute(builder: (context) => const TranslatorScreen())));
            },
          ),
          ListTile(
            leading: Icon(Icons.image_search, color: Colors.white,),
            title: Text("Text to Image", style: TextStyle(color: Colors.white),),
            onTap: (){
              Navigator.push(context, (MaterialPageRoute(builder: (context) => const TextToImageScreen())));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout,color: Colors.white,),
            title: Text(AppLocalizations.of(context)!.logout, style: TextStyle(color: Colors.white),),
            onTap: (){
              FirebaseAuth.instance.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace){
                print("Error${error.toString()}");
              });
            },
          ),
        ],
      ),
    );
  }
}
