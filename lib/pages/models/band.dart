class Band {
  String id;
  String name;
  int votes;

  Band({this.id, this.name, this.votes});

  //esto regresa un nuevo objeto de este tipo pasandole un MAP
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']
  );   
}
