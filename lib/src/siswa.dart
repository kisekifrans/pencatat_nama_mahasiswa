class Siswa {
  late int id;
  late String nama;

  Siswa(this.id, this.nama);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nama': nama,
    };
    return map;
  }

  Siswa.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nama = map['nama'];
  }
}
