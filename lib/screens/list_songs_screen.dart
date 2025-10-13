import 'package:flutter/material.dart';
// TODO: Add import for your songs Firebase service
// import 'package:pmsn20252/firebase/songs_firebase.dart';

class ListSongsScreen extends StatefulWidget {
  const ListSongsScreen({super.key});

  @override
  State<ListSongsScreen> createState() => _ListSongsScreenState();
}

class _ListSongsScreenState extends State<ListSongsScreen> {
  // TODO: Initialize your songs Firebase service
  // SongsFirebase? songsFirebase;

  @override
  void initState() {
    super.initState();
    // songsFirebase = SongsFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Songs')),
      body: StreamBuilder(
        // stream: songsFirebase!.selectAllSongs(),
        stream: Stream.empty(), // Temporary placeholder
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                // TODO: Replace with your song model
                final song = snapshot.data![index];
                return ListTile(
                  title: Text('Song Title'), // Replace with song.title
                  subtitle: Text('Artist Name'), // Replace with song.artist
                  leading: Icon(Icons.music_note),
                  onTap: () {
                    // Handle song selection
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
