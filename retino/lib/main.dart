import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retino/service/pick_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await DesktopWindow.setMinWindowSize(const Size(960, 600));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.dark,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      body: ChangeNotifierProvider<PickImage>(
        create: (ctx) => PickImage(),
        child: Consumer<PickImage>(builder: (context, image, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: double.infinity),
              image.me.isEmpty && image.load == false
                  ? Center(
                      child: Text(
                        'Retinopathy+',
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: CupertinoColors.white),
                      ),
                    )
                  : Text(
                      image.me,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: image.val[image.me],
                          fontWeight: FontWeight.bold),
                    ),
              image.load
                  ? Container(
                      width: MediaQuery.of(context).size.height * 0.9,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(image.image!),
                          fit: BoxFit.fitHeight,
                        ),
                        color: CupertinoColors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      height: MediaQuery.of(context).size.height * 0.6,
                    )
                  : const SizedBox(),
              image.sendData
                  ? const CupertinoActivityIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image.load
                            ? CupertinoButton(
                                color: CupertinoColors.activeGreen,
                                child: const Text("Predict"),
                                onPressed: () async {
                                  await image.getresult(image.image!);
                                },
                              )
                            : const SizedBox(),
                        const SizedBox(width: 10),
                        CupertinoButton(
                          color: image.load
                              ? CupertinoColors.destructiveRed
                              : CupertinoColors.activeBlue,
                          child: Text(image.load ? "Remove" : "Open Image"),
                          onPressed: () {
                            if (image.load) {
                              image.removeImage();
                            } else {
                              image.pickImage();
                            }
                          },
                        ),
                      ],
                    ),
            ],
          );
        }),
      ),
    );
  }
}
