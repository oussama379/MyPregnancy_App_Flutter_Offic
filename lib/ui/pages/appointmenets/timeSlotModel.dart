class TimeSlot{
  String id2;
  String id1;
  int nombre;

  TimeSlot(this.id2, this.id1, this.nombre);
  factory TimeSlot.fromJson(dynamic json) {
    return TimeSlot(json['id2'] as String, json['id1'] as String, json['nombre'] as int);
  }
  Map<dynamic, dynamic> toJson() =>
      {'id2': id2, 'id1': id1, 'nombre': nombre};

  @override
  String toString() {
    return 'Cx{id2: $id2, id1: $id1}';
  }
}