class Siswa {
  int? id;
  late String nama;
  late String nim;

  Siswa(this.id, this.nama, this.nim);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'nama': nama,
      'nim': nim,
    };
    return map;
  }

  Siswa.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nama = map['nama'];
    nim = map['nim'];
  }
}
