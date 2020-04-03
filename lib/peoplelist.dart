import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:api/person.dart';

class PeopleList extends StatefulWidget{
  PeopleListState createState() => PeopleListState();
}

class PeopleListState extends State<PeopleList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People'),),
      body: scaffoldBody,
      floatingActionButton: FloatingActionButton(
      // An Add button. When the user taps it, we send
      // them to PeopleUpsert with NO person object.
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/peopleUpsert');
          setState((){});
        },
      ),
    );
  }

  // Note how we pull out details to make the widget more
  // abstract for you. We do the same with personWidget below.
  Widget get scaffoldBody {
    return FutureBuilder<dynamic>(
      future: fetchPeople(), // How we'll get the people
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Oh no! Error! ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Text('No people found');
        }
        // Convert the JSON data to an array of Persons
        final List<Person> people =
        Person.fromJsonArray(snapshot.data.body);
        // Convert the list of persons to a list of widgets
        final List<Widget> personTiles = people.map<Widget>((Person person) => personWidget(person)).toList();
        // Display all the person tiles in a scrollableGridView
        return GridView.extent(
          maxCrossAxisExtent: 300,
          children: personTiles,
        );
      },
    );
  }

  // Displaying a single person tile.
  Widget personWidget(Person person) {
    Map<String,String> name = person.name;
    String email = person.email;
    String imageUrl = person.imageUrl;
    return GestureDetector(
      child: Card(
        child: Stack(
          children: <Widget>[
            Image.network(
              imageUrl,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${name['first']} ${name['last']}",
                        style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white,),
                      onPressed: () => deletePerson(person),
                    ),
                  ],
                ),
                Expanded(child: Container(),),
                Text(
                  email,
                  style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/peopleUpsert', arguments: person);
        setState((){});
      },
    );
  }

  Future<dynamic> fetchPeople() {
  // pipedreamRESTUrl is the URL you made note of before
    final String url = 'https://shapi1.000webhostapp.com/showPeople.php';
    return get(url);
  }

  void deletePerson(Person person) {
    final String url = 'https://shapi1.000webhostapp.com/deletePerson.php?id=${person.id}';
    get(url).then((Response res) {
      // Call setState() to rerender AFTER the person is gone
      setState(() {
        print('Status code: ${res.statusCode}');
      });
    });
  }
}