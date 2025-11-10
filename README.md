**Tugas 1**: Geocoding (Alamat dari Koordinat)
Saat ini kita hanya menampilkan Lat/Lng. Buatlah agar aplikasi menampilkan alamat
(nama jalan, kota, dll) dari koordinat yang didapat.
Petunjuk:
1. Anda sudah menambahkan paket geocoding di pubspec.yaml.
<img width="776" height="454" alt="image" src="https://github.com/user-attachments/assets/64314c1c-46e2-4e07-bfab-d7bd89bb67d4" />

2. Import paketnya: import ’package:geocoding/geocoding.dart’;
<img width="1012" height="380" alt="image" src="https://github.com/user-attachments/assets/d7dfb8ed-aaf1-46cd-9e26-eda13a7db1ec" />

3. Buat variabel String? currentAddress; di MyHomePageState.
<img width="1416" height="492" alt="image" src="https://github.com/user-attachments/assets/69526d57-0686-4c4f-8355-3d4f0f544ab1" />

4. Buat fungsi baru getAddressFromLatLng(Position position).
<img width="1788" height="1050" alt="image" src="https://github.com/user-attachments/assets/709d74ee-9f5b-4efa-8257-31820f56ea76" />

5.  Panggil fungsi getAddressFromLatLng( currentPosition!) di dalam getLocation dan startTracking (di dalam .listen()) setelah setState untuk currentPosition.
<img width="944" height="380" alt="image" src="https://github.com/user-attachments/assets/30aee748-4098-40cb-b221-06d4dafbd22f" />
<img width="1080" height="380" alt="image" src="https://github.com/user-attachments/assets/a2b71d4a-4b53-4db6-9e23-c47527827cf0" />

6. Tampilkan currentAddress di UI Anda, di bawah Lat/Lng.
   <img width="610" height="212" alt="image" src="https://github.com/user-attachments/assets/54de7c37-8f94-4bce-85f2-5619eca927b7" />

   ## Hasil
   ![WhatsApp Image 2025-11-10 at 15 53 14_618506ef](https://github.com/user-attachments/assets/3e5d1a5b-fd4c-4657-81cc-30bd2da2f46b)





#Hasil
![WhatsApp Image 2025-11-10 at 15 53 14_6a300021](https://github.com/user-attachments/assets/e5119959-096e-4d02-a306-9a6058d8354d)

