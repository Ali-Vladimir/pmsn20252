# Configuración Firebase (OPCIONAL - No necesario para la práctica)

## Si en el futuro quieres usar Firebase para Planetas y Reservaciones

### 1. Crear colecciones en Firestore

Ve a tu consola de Firebase → Firestore Database y crea:

#### Colección: `planets`
```
planets/
  └─ {planetId}/
      ├─ namePlanet: string
      ├─ description: string
      ├─ imagePath: string
      ├─ mass: string
      ├─ gravity: string
      ├─ dayLength: string
      ├─ escapeVelocity: string
      ├─ meanTemp: string
      ├─ distanceFromSun: string
      ├─ isFavorite: boolean
      └─ createdAt: timestamp
```

#### Colección: `reservations`
```
reservations/
  └─ {reservationId}/
      ├─ idPlanet: string (referencia al planetId)
      ├─ planetName: string (denormalizado)
      ├─ visitorName: string
      ├─ reservationDate: string (ISO format)
      ├─ visitTime: string
      ├─ status: string (pending|confirmed|cancelled)
      ├─ notes: string
      └─ createdAt: timestamp
```

### 2. Reglas de Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Reglas para planets
    match /planets/{planetId} {
      // Cualquiera puede leer
      allow read: if true;
      // Solo usuarios autenticados pueden escribir
      allow write: if request.auth != null;
    }
    
    // Reglas para reservations
    match /reservations/{reservationId} {
      // Cualquiera puede leer
      allow read: if true;
      // Solo usuarios autenticados pueden crear
      allow create: if request.auth != null;
      // Solo el creador puede actualizar/eliminar
      allow update, delete: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

### 3. Crear archivo planets_firebase.dart (si lo necesitas)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsn20252/models/planet_dao.dart';

class PlanetsFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _planetsCollection => 
    _firestore.collection('planets');
  
  // Insertar planeta
  Future<void> insertPlanet(PlanetDao planet) async {
    await _planetsCollection.add({
      'namePlanet': planet.namePlanet,
      'description': planet.description,
      'imagePath': planet.imagePath,
      'mass': planet.mass,
      'gravity': planet.gravity,
      'dayLength': planet.dayLength,
      'escapeVelocity': planet.escapeVelocity,
      'meanTemp': planet.meanTemp,
      'distanceFromSun': planet.distanceFromSun,
      'isFavorite': planet.isFavorite == 1,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Obtener todos los planetas
  Stream<List<PlanetDao>> getAllPlanets() {
    return _planetsCollection
      .orderBy('namePlanet')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return PlanetDao(
            idPlanet: doc.id.hashCode,
            namePlanet: data['namePlanet'],
            description: data['description'],
            imagePath: data['imagePath'],
            mass: data['mass'],
            gravity: data['gravity'],
            dayLength: data['dayLength'],
            escapeVelocity: data['escapeVelocity'],
            meanTemp: data['meanTemp'],
            distanceFromSun: data['distanceFromSun'],
            isFavorite: data['isFavorite'] ? 1 : 0,
          );
        }).toList();
      });
  }
  
  // Actualizar planeta
  Future<void> updatePlanet(String docId, PlanetDao planet) async {
    await _planetsCollection.doc(docId).update({
      'namePlanet': planet.namePlanet,
      'description': planet.description,
      'imagePath': planet.imagePath,
      'mass': planet.mass,
      'gravity': planet.gravity,
      'dayLength': planet.dayLength,
      'escapeVelocity': planet.escapeVelocity,
      'meanTemp': planet.meanTemp,
      'distanceFromSun': planet.distanceFromSun,
      'isFavorite': planet.isFavorite == 1,
    });
  }
  
  // Eliminar planeta
  Future<void> deletePlanet(String docId) async {
    await _planetsCollection.doc(docId).delete();
  }
  
  // Obtener planetas favoritos
  Stream<List<PlanetDao>> getFavoritePlanets() {
    return _planetsCollection
      .where('isFavorite', isEqualTo: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return PlanetDao(
            idPlanet: doc.id.hashCode,
            namePlanet: data['namePlanet'],
            description: data['description'],
            imagePath: data['imagePath'],
            mass: data['mass'],
            gravity: data['gravity'],
            dayLength: data['dayLength'],
            escapeVelocity: data['escapeVelocity'],
            meanTemp: data['meanTemp'],
            distanceFromSun: data['distanceFromSun'],
            isFavorite: 1,
          );
        }).toList();
      });
  }
}
```

### 4. Índices compuestos (si usas queries complejas)

En Firebase Console → Firestore → Indexes, crea:

```
Collection: reservations
Fields: reservationDate (Ascending) + visitTime (Ascending)
Query Scope: Collection
```

---

## ⚠️ IMPORTANTE

**NO necesitas hacer nada de esto ahora**. La práctica funciona perfectamente con SQLite local. Solo usa esta guía si en el futuro quieres:
- Sincronizar datos entre dispositivos
- Compartir planetas entre usuarios
- Hacer backup en la nube

## 🎯 Para la práctica actual:

✅ **Todo ya está funcionando** con SQLite local
✅ No necesitas cambios en Firebase
✅ Los datos se guardan en el dispositivo
✅ Firebase solo se usa para Songs y Auth (que ya funcionan)
