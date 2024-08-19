var baseUrl = 'https://backendrumahbumn-production.up.railway.app';
// var baseUrl = 'http://192.168.28.196:4000';

//users
var signIn = Uri.parse("$baseUrl/users/login");
var signUp = Uri.parse("$baseUrl/users/registrasi");

//barang
var dataBarangRes = Uri.parse("$baseUrl/barang/get-all-barang");
var dataKategori = Uri.parse("$baseUrl/kategori/getAllKategori");

//keranjang
var inputKeranjangRes = Uri.parse("$baseUrl/keranjang/input-keranjang");
var getAllKeranjangRes = "$baseUrl/keranjang/get-all-keranjang";
var updateKeranjangRes = "$baseUrl/keranjang/update-keranjang";
var hapusKeranjangRes = "$baseUrl/keranjang/delete-keranjang";

//transaksi
var transaksiInput = Uri.parse("$baseUrl/transaksi/input-transaksi");
var transaksiUpdate = Uri.parse("$baseUrl/transaksi/update");
var transaksiUpdateRetur = Uri.parse("$baseUrl/transaksi/updateRetur");
var transaksiCancelRetur = Uri.parse("$baseUrl/transaksi/cancelRetur");
var getTransaksi = Uri.parse("$baseUrl/transaksi/get-transaksi-by-idUser");

//uploadSertifikasi
var sertifikasi = Uri.parse("$baseUrl/sertifikasi/upload");
var sertifikasiGetAll = Uri.parse("$baseUrl/sertifikasi/get-all");
