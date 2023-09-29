import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:envied/envied.dart';
import 'env/env.dart';
import 'main.dart';
import "dart:math";



const primaryColor = Colors.cyan;

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  RandomWordsState createState() => RandomWordsState();
}//randomwords class


class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = <WordPair>{};
  var defineWord = WordPair("ping","pong");

  final myWords = ["Brady", "Braden", "Christopher", "Norum", 
                   "Mobile", "Development", "Physics","Evil",
                   "Dead","Alive", "Pepsi", "Epic"];

  Iterable<WordPair> _generateMyPairs() {
    var generatedWords = <WordPair>[];
    for (var i = 0; i < 11; i++) {
     final random = Random();
     final word1i = random.nextInt(myWords.length);
     var word2i = random.nextInt(myWords.length);
     while (word1i == word2i) {word2i = random.nextInt(myWords.length);}
     final generatedpair = WordPair(myWords[word1i],myWords[word2i]);
     generatedWords.add(generatedpair);
    }
    
    return generatedWords;
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if(item.isOdd) return const Divider();
        final index = item ~/ 2;

        if(index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(_generateMyPairs().take(10));
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  } //_buildlist
  
  
  Widget _buildRow(WordPair pair){
    final alreadySaved = _savedWordPairs.contains(pair);
    

    return ListTile(
      title: Text(pair.asPascalCase, 
        style: const TextStyle(fontSize: 18.0)
        ),
      trailing: alreadySaved ? const CircleAvatar(backgroundImage: AssetImage('assets/liked.jpg')) 
                             : const CircleAvatar(backgroundImage: AssetImage('assets/unliked.jpg')),
      onTap: () {
        setState(() {
          if(alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }//else
        });//set state
      }
    );

  } //_buildrow

  
  void _pushWordDef() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              centerTitle: true,
              title: const Text("Definition")),
            body: FutureBuilder<String>(
              future: _chatGPTdefinition(),
              initialData: "Computing...",
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                
                if (snapshot.hasData) {
                  return Container( 
                    padding: const EdgeInsets.all(32),
                    child: Text(snapshot.data!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  )
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          );
        }
      )
    );
  }
 
  Future<String>  _chatGPTdefinition() async  {
      OpenAI.apiKey = Env.apiKey;
      OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo",
          messages: [
            OpenAIChatCompletionChoiceMessageModel(
              content: "\n\nGive a hypothetical definition to the made up word $defineWord",
              role: OpenAIChatMessageRole.user,
              ),
          ],
      );
      
      String result = chatCompletion.choices[0].message.content;
      return Future.delayed(const Duration(seconds: 2), ()=> result);
  }
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair){
            return ListTile(
              title: Text(
                pair.asPascalCase, 
                style: const TextStyle(fontSize: 16.0)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () { defineWord = pair;  _pushWordDef(); }
            );
          });

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              centerTitle: true,
              title: const Text('Saved Word Pairs')),
            body: ListView(children: divided)
          );
        }
      )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('Word Pair Generator'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved
          )
        ],
        ),
        
      body: _buildList()
    );
  }//build

}