import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import "dart:math";


const primaryColor = Colors.cyan;
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}//randomwords class


class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  final myWords = ["Brady", "Braden", "Christopher", "Norum", 
                   "Mobile", "Development", "Physics","Evil",
                   "Dead","Alive", "Pepsi", "Epic"];

  Iterable<WordPair> _generateMyPairs() {
    var generatedWords = <WordPair>[];
    for (var i = 0; i < 11; i++) {
     final random = new Random();
     final word1i = random.nextInt(myWords.length);
     var word2i = random.nextInt(myWords.length);
     if (word1i == word2i) {word2i = random.nextInt(myWords.length);}
     final generatedpair = WordPair(myWords[word1i],myWords[word2i]);
     generatedWords.add(generatedpair);
    }
    
    return generatedWords;
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if(item.isOdd) return Divider();
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

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair){
            return ListTile(
              title: Text(
                pair.asPascalCase, 
                style: const TextStyle(fontSize: 16.0)));
          });

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              centerTitle: true,
              title: const Text('Saved WordPairs')),
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
        title: const Text('Word Pair Gen'),
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