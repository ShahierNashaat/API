import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'person.dart';

class PeopleUpsert extends StatefulWidget{
  @override
  _PeopleUpsertState createState() => _PeopleUpsertState();
}

class _PeopleUpsertState extends State<PeopleUpsert>{
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  Person person;

  @override
  Widget build(BuildContext context) {
    // Get the 'current' person set during navigation. If
    // this person is null, we're adding a new person so
    // we should instantiate one. If this person is not null,
    // then we're updating that person.
    final Person _person = ModalRoute.of(context).settings.arguments as Person;
    person = (_person == null) ? Person() : _person;
    return Scaffold(
      appBar: AppBar(
        title: Text((_person == null) ? 'Add a person' : 'Update a person'),
      ),
      body: _body,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if (_key.currentState.validate()) {
            // Similarly this calls onSaved() for all fields
            _key.currentState.save();
            // You'd save the data to a database or whatever here
            print('Successfully saved the state.');
          }
          else{
            return;
          }
          // Save the person
          updatePersonToPipedream(person);
          // And go back to where we came from
          Navigator.pop<Person>(context, person);
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget get _body {
    return Form(
      key: _key,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: person.name['first'],
              decoration: InputDecoration(labelText: 'First name'),
              onSaved: (String val) => person.name['first']=val,
              validator: (String val){
                if (val.isEmpty)
                  return 'Please enter your first name';
                return null;
              },
            ),
            TextFormField(
              initialValue: person.name['last'],
              decoration: InputDecoration(labelText: 'Last name'),
              onSaved: (String val) => person.name['last']=val,
              validator: (String val){
                if (val.isEmpty)
                  return 'Please enter your last name';
                return null;
              },
            ),
            TextFormField(
              initialValue: person.email,
              decoration: InputDecoration(labelText: 'Email'),
              onSaved: (String val) => person.email=val,
              validator: (String val){
                if (val.isEmpty)
                  return 'Please enter your email';
                return null;
              },
            ),
            TextFormField(
              initialValue: person.imageUrl,
              decoration: InputDecoration(labelText: 'Image URL'),
              onSaved: (String val) => person.imageUrl=val,
              validator: (String val){
                if (val.isEmpty)
                  return 'Please enter your image url';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future updatePersonToPipedream(Person person) async{
    var response;
    final String payload = """
    {
      "first":"${person.name['first']}",
      "last":"${person.name['last']}",
      "imageUrl":"${person.imageUrl}",
      "email":"${person.email}"
    }
    """;
    final Map<String, String> headers = <String, String>{
      'Content-type': 'application/json'
    };
    // If id is null, we're adding. If not, we're updating.
    if(person.id == null){
      String url = 'https://shapi1.000webhostapp.com/addPerson.php';
      response = await post(url, headers: headers, body: payload);
    }else{
      String url = 'https://shapi1.000webhostapp.com/updatePerson.php?id=${person.id}';
      response = await post(url, headers: headers, body: payload);
    }
  }
}