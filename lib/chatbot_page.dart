import 'package:flutter/material.dart';
import 'plant_chatbot.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController controller = TextEditingController();
  List<Map<String, String>> messages = [];
  String currentLang = "en"; // Default language

  @override
  void initState() {
    super.initState();
    PlantChatBot.loadData();
  }

  void sendMessage() {
    String question = controller.text.trim();
    if (question.isEmpty) return;

    controller.clear();

    setState(() {
      messages.add({"role": "user", "text": question});
      messages.add({
        "role": "bot",
        "text": PlantChatBot.getResponse(question, lang: currentLang)
      });
    });
  }

  void toggleLanguage() {
    setState(() {
      currentLang = (currentLang == "en") ? "ar" : "en";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text("PlantPal Chatbot", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: toggleLanguage,
            child: Text(
              currentLang == "en" ? "AR" : "EN",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i]!;
                bool isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[300] : Colors.brown[100],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(Icons.agriculture, color: Colors.green[800]),
                          ),
                        Expanded(
                          child: Directionality(
                            textDirection: isUser
                                ? TextDirection.ltr
                                : (currentLang == "ar" ? TextDirection.rtl : TextDirection.ltr),
                            child: Text(
                              msg["text"]!,
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        ),
                        if (isUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(Icons.person, color: Colors.green[900]),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.green[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: currentLang == "en"
                          ? "Ask me about plants..."
                          : "اسألني عن النباتات...",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: sendMessage,
                  mini: true,
                  backgroundColor: Colors.green[700],
                  child: Icon(Icons.send, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
