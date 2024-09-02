

import 'package:chatgpt_app/constants/vision_api_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class TextToImageScreen extends StatefulWidget {
  const TextToImageScreen({super.key});

  @override
  State<TextToImageScreen> createState() => _TextToImageScreenState();
}

class _TextToImageScreenState extends State<TextToImageScreen> {

  TextEditingController controller = TextEditingController();
  final VisionCraft visionCraft = VisionCraft();
  Uint8List? imageResult;
  bool? isLoading;

  /// [apiKey] get your free api key on https://t.me/VisionCraft_bot by sending /Key.
  String apiKey = "a3a824ef-3708-403d-911c-dd8ab0be8f32";

  Future<void> createImage() async {
    String prompt = controller.text.trim().toString();
    final result = await visionCraft.generateImage(
      apiKey: apiKey,
      prompt: prompt,
      enableBadWords: false,
    );
    imageResult = result;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Vision Craft Example',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Get Model List"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Get Sapmlers List"),
                  ),
                ];
              }, onSelected: (value) {
            if (value == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GetAvailableSamplers(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GetAllSamplersExapmle(),
                ),
              );
            }
          }),
        ],
      ),
      body: isLoading != null && isLoading == true
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // TextField for prompt
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey.shade300,
                ),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter query text...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8),
                ),
              ),
            ),
            // Image result.
            imageResult == null
                ? const Center(
              child: Text("Enter prompt to create image"),
            )
                : Container(
              height: 300,
              margin: const EdgeInsets.all(8.0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(imageResult!),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          /// Create image and set loading to true [createImage()]
          isLoading = true;
          setState(() {});
          createImage();
        },
        child: const Icon(
          Icons.create,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Example of getting models [GetAvailableSamplers]
class GetAvailableSamplers extends StatefulWidget {
  const GetAvailableSamplers({super.key});

  @override
  State<GetAvailableSamplers> createState() => _GetAvailableSamplersState();
}

class _GetAvailableSamplersState extends State<GetAvailableSamplers> {
  List<String> models = [];
  final VisionCraft visionCraft = VisionCraft();

  Future<void> getModelList() async {
    final result = await visionCraft.getModelList();
    models = result;

    /// Print Models.
    for (int i = 0; i < result.length; i++) {
      print(result[i]);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getModelList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'GetModels Example',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: models.isEmpty
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      )
          : ListView.builder(
        itemCount: models.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(models[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          /// Refresh
          models.clear();
          getModelList();
          setState(() {});
        },
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Example of gettings available samplers
class GetAllSamplersExapmle extends StatefulWidget {
  const GetAllSamplersExapmle({super.key});

  @override
  State<GetAllSamplersExapmle> createState() => _GetAllSamplersExapmleState();
}

class _GetAllSamplersExapmleState extends State<GetAllSamplersExapmle> {
  List<String> samplers = [];
  final VisionCraft visionCraft = VisionCraft();

  Future<void> getSamplersList() async {
    final result = await visionCraft.getSamplerList();
    samplers = result;

    /// Print Models.
    for (int i = 0; i < result.length; i++) {
      print(result[i]);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSamplersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'GetSamplers Example',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: samplers.isEmpty
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      )
          : ListView.builder(
        itemCount: samplers.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(samplers[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          /// Refresh
          samplers.clear();
          getSamplersList();
          setState(() {});
        },
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }
}