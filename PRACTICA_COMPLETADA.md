# Práctica Completada - Sistema de Gestión de Planetas y Reservaciones

## 📋 Resumen de Implementación

Esta práctica implementa un sistema completo de gestión de planetas del sistema solar con reservaciones, utilizando base de datos SQLite con tablas relacionadas y widgets personalizados.

---

## ✅ Requisitos Completados

### 1. **CRUDs con Base de Datos** ✓

#### Modelos DAO Creados:
- **`PlanetDao`** (`lib/models/planet_dao.dart`)
  - Campos: idPlanet, namePlanet, description, imagePath, mass, gravity, dayLength, escapeVelocity, meanTemp, distanceFromSun, isFavorite
  - Métodos: `toMap()`, `fromMap()`

- **`ReservationDao`** (`lib/models/reservation_dao.dart`)
  - Campos: idReservation, idPlanet, visitorName, reservationDate, visitTime, status, notes, createdAt
  - Métodos: `toMap()`, `fromMap()`

#### Base de Datos (`lib/database/movies_database.dart`):
- **Tabla `tblplanets`**: Almacena información de planetas
- **Tabla `tblreservations`**: Almacena reservaciones de visitas a planetas
- **Relación**: FOREIGN KEY entre `tblreservations.idPlanet` y `tblplanets.idPlanet`

#### Operaciones CRUD Implementadas:

**Planetas:**
- `insertPlanet()` - Crear nuevo planeta
- `updatePlanet()` - Actualizar planeta existente
- `deletePlanet()` - Eliminar planeta (elimina reservaciones relacionadas por CASCADE)
- `getAllPlanets()` - Obtener todos los planetas
- `getFavoritePlanets()` - Obtener planetas favoritos
- `getPlanetById()` - Obtener planeta por ID

**Reservaciones:**
- `insertReservation()` - Crear nueva reservación (valida que el planeta exista)
- `updateReservation()` - Actualizar reservación existente
- `deleteReservation()` - Eliminar reservación
- `getAllReservations()` - Obtener todas las reservaciones
- `getReservationsByDate()` - Obtener reservaciones por fecha
- `getReservationsByPlanet()` - Obtener reservaciones de un planeta
- `getReservationWithPlanet()` - Obtener reservación con JOIN a planeta
- `getAllReservationsWithPlanets()` - Obtener todas con información del planeta

---

### 2. **Pantalla de Calendario** ✓

**Archivo**: `lib/screens/cosmic/reservations_calendar_screen.dart`

**Características:**
- Calendario interactivo usando `table_calendar` package
- Visualización de reservaciones por fecha
- Marcadores en días con reservaciones
- Lista de reservaciones del día seleccionado
- Indicadores de estado con colores:
  - 🟢 Verde: Confirmed (confirmada)
  - 🟠 Naranja: Pending (pendiente)
  - 🔴 Rojo: Cancelled (cancelada)
- Navegación a formulario de nueva reservación
- Eliminación de reservaciones con confirmación
- Filtrado y ordenamiento por fecha y hora

---

### 3. **Integridad Referencial** ✓

#### Validación de Integridad:

**En Base de Datos:**
```sql
FOREIGN KEY (idPlanet) REFERENCES tblplanets(idPlanet)
  ON DELETE CASCADE
  ON UPDATE CASCADE
```

**En Código:**
- Validación antes de insertar reservación (verifica que el planeta exista)
- Validación antes de actualizar reservación
- Eliminación en cascada automática (al eliminar planeta, se eliminan sus reservaciones)
- Manejo de errores con excepciones

---

### 4. **Widgets Nuevos y Diferentes** ✓

#### Widget 1: **FlipCard** (Tarjeta con Animación Flip 3D)
**Archivo**: `lib/widgets/flip_card.dart`

**Características:**
- Animación 3D de volteo usando `Transform` y `Matrix4`
- Dos caras: frontal y posterior
- Rotación suave con curva de animación
- Tap para voltear
- Duración personalizable

**Uso**: Implementado en `inner_page_screen.dart` para mostrar información adicional del planeta

#### Widget 2: **ParallaxImage** y **AnimatedParallax**
**Archivo**: `lib/widgets/parallax_image.dart`

**Características:**
- Efecto parallax en imágenes de fondo
- Animación continua y suave
- Movimiento vertical automático
- Superposición de contenido
- Repetición infinita con reversa

**Uso**: Implementado en `profile_screen.dart` como banner hero con efecto parallax

---

## 🗂️ Pantallas Cosmic Implementadas

### 1. **HomeScreenCosmic** (Pantalla Principal)
- Lista horizontal de planetas con quick access
- Botón "View All" para ver todos los planetas
- Planet of the Day destacado
- Acceso a calendario (botón superior derecho)
- Acceso a perfil (botón superior izquierdo)
- Información del sistema solar

### 2. **PlanetsListScreen** (Lista Completa de Planetas)
**Archivo**: `lib/screens/cosmic/planets_list_screen.dart`

**Características:**
- Lista completa de todos los planetas
- Deslizable para editar o eliminar (`flutter_slidable`)
- Navegación a detalles del planeta
- Botón flotante para agregar nuevo planeta
- Confirmación antes de eliminar

### 3. **AddPlanetScreen** (Agregar/Editar Planeta)
**Archivo**: `lib/screens/cosmic/add_planet_screen.dart`

**Características:**
- Formulario completo para datos del planeta
- Selector de imagen (camera/gallery)
- Campos: nombre, descripción, masa, gravedad, duración del día, velocidad de escape, temperatura, distancia del sol
- Toggle para marcar como favorito
- Validación de formulario
- Modo edición y creación

### 4. **InnerPageScreen** (Detalles del Planeta)
- Visualización completa de datos del planeta
- Estadísticas en grid layout
- **FlipCard** con información adicional (nuevo widget)
- Botón de favorito con toggle
- Animación de entrada
- Botón de visita

### 5. **FavoritesScreen** (Planetas Favoritos)
- Lista filtrada de planetas favoritos
- Actualización dinámica al cambiar favoritos
- Navegación a detalles
- Estado vacío cuando no hay favoritos

### 6. **ReservationsCalendarScreen** (Calendario de Reservaciones)
- Calendario mensual interactivo
- Marcadores de eventos
- Lista de reservaciones por día
- Botón flotante para nueva reservación

### 7. **AddReservationScreen** (Agregar Reservación)
**Archivo**: `lib/screens/cosmic/add_reservation_screen.dart`

**Características:**
- Selector de planeta (dropdown)
- Selector de fecha (date picker)
- Selector de hora (time picker)
- Selector de estado (pending/confirmed/cancelled)
- Campo de notas opcional
- Validación de formulario
- Modo edición y creación

### 8. **ProfileScreen** (Perfil)
- **AnimatedParallax** como banner hero (nuevo widget)
- Información del usuario
- Sección de progreso
- Diseño consistente con el tema cosmic

---

## 🎨 Widgets Adicionales Utilizados

### Ya existentes en el proyecto:
1. **Shimmer** - Efecto de carga en home screen
2. **Flutter Slidable** - Deslizamiento en lista de planetas
3. **Animated Text Kit** - Animaciones de texto

### Nuevos implementados en esta práctica:
4. **FlipCard** - Tarjeta con animación flip 3D ⭐ NUEVO
5. **ParallaxImage / AnimatedParallax** - Efecto parallax en imágenes ⭐ NUEVO
6. **Table Calendar** - Calendario interactivo (requerido)

---

## 📊 Estructura de la Base de Datos

### Tabla: `tblplanets`
```sql
CREATE TABLE tblplanets(
  idPlanet INTEGER PRIMARY KEY AUTOINCREMENT,
  namePlanet VARCHAR(50) NOT NULL,
  description TEXT,
  imagePath VARCHAR(100),
  mass VARCHAR(20),
  gravity VARCHAR(20),
  dayLength VARCHAR(20),
  escapeVelocity VARCHAR(20),
  meanTemp VARCHAR(20),
  distanceFromSun VARCHAR(20),
  isFavorite INTEGER DEFAULT 0
)
```

### Tabla: `tblreservations`
```sql
CREATE TABLE tblreservations(
  idReservation INTEGER PRIMARY KEY AUTOINCREMENT,
  idPlanet INTEGER NOT NULL,
  visitorName VARCHAR(100) NOT NULL,
  reservationDate TEXT NOT NULL,
  visitTime VARCHAR(10),
  status VARCHAR(20) DEFAULT 'pending',
  notes TEXT,
  createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (idPlanet) REFERENCES tblplanets(idPlanet)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
```

**Relación**: Uno a Muchos (un planeta puede tener muchas reservaciones)

---

## 🚀 Navegación Implementada

### Desde HomeScreenCosmic:
- ➡️ PlanetsListScreen (botón "View All")
- ➡️ InnerPageScreen (tap en planeta)
- ➡️ ReservationsCalendarScreen (botón calendario)
- ➡️ ProfileScreen (botón perfil)

### Desde PlanetsListScreen:
- ➡️ AddPlanetScreen (FAB, para crear)
- ➡️ AddPlanetScreen (slide edit, para editar)
- ➡️ InnerPageScreen (tap en planeta)

### Desde ReservationsCalendarScreen:
- ➡️ AddReservationScreen (FAB)

### Home Screen Principal (Bottom Navigation):
- Tab 1: CharactersListScreen
- Tab 2: ListSongsScreen
- Tab 3: FavoritesScreen (Cosmic)
- Tab 4: HomeScreenCosmic

---

## 🎯 Funcionalidades Destacadas

### Validaciones Implementadas:
- ✓ Verificación de planeta existente antes de crear reservación
- ✓ Validación de formularios (campos requeridos)
- ✓ Confirmación antes de eliminar (diálogos)
- ✓ Manejo de errores con try-catch

### Características UX/UI:
- ✓ Feedback visual (SnackBars)
- ✓ Loading states (CircularProgressIndicator)
- ✓ Empty states (mensajes cuando no hay datos)
- ✓ Animaciones suaves
- ✓ Tema oscuro cosmic consistente
- ✓ Iconografía clara y descriptiva

### Data Seeding:
- ✓ PlanetsSeeder con 8 planetas del sistema solar pre-cargados
- ✓ Verificación para no duplicar datos

---

## 📦 Dependencias Utilizadas

```yaml
dependencies:
  flutter_slidable: ^3.1.1      # Deslizamiento en listas
  shimmer: ^3.0.0               # Efecto shimmer de carga
  animated_text_kit: ^4.2.2     # Animaciones de texto
  table_calendar: ^3.1.2        # Calendario (NUEVO)
  intl: ^0.19.0                 # Formateo de fechas
  sqflite: ^2.4.1               # Base de datos SQLite
  path_provider: ^2.1.5         # Acceso a directorios
  image_picker: ^1.0.4          # Selección de imágenes
```

---

## 🎓 Aprendizajes Aplicados

1. **Bases de Datos Relacionales**
   - Diseño de tablas relacionadas
   - Foreign Keys y integridad referencial
   - Operaciones CASCADE

2. **Arquitectura de Código**
   - Patrón DAO (Data Access Object)
   - Separación de responsabilidades
   - Reutilización de componentes

3. **UI/UX Avanzado**
   - Widgets personalizados
   - Animaciones 3D
   - Efectos visuales (parallax, flip)
   - Calendarios interactivos

4. **Gestión de Estado**
   - StatefulWidgets
   - Actualización dinámica de UI
   - Manejo de eventos async

---

## 🔧 Instrucciones de Uso

### Para ejecutar el proyecto:
```bash
flutter pub get
flutter run
```

### Para probar las funcionalidades:

1. **Explorar Planetas**:
   - Navega a la tab "Cosmic" (icono de email)
   - Explora los planetas en la lista horizontal
   - Tap en "View All" para ver todos los planetas

2. **Ver Detalles de Planeta**:
   - Tap en cualquier planeta
   - Tap en la tarjeta azul para voltearla (FlipCard)
   - Marca/desmarca como favorito

3. **Crear Reservación**:
   - Tap en el botón de calendario (esquina superior derecha)
   - Tap en el botón flotante "New Reservation"
   - Completa el formulario y guarda

4. **Ver Calendario**:
   - Los días con reservaciones tienen marcadores
   - Selecciona un día para ver sus reservaciones
   - Tap en el ícono de eliminar para borrar

5. **Gestionar Planetas**:
   - En "View All", desliza un planeta hacia la izquierda
   - Opciones: Edit (azul) o Delete (rojo)

---

## 📝 Notas Técnicas

- **Versión de Base de Datos**: 2 (incrementada para incluir nuevas tablas)
- **Persistencia**: Los datos se mantienen entre sesiones
- **Imágenes**: Se usan assets pre-definidos para planetas
- **Estados de Reservación**: pending, confirmed, cancelled
- **Formato de Fechas**: ISO 8601 (yyyy-MM-dd)

---

## ✨ Características Adicionales Implementadas

- Búsqueda visual de planetas
- Indicadores de estado con colores
- Gradientes y sombras personalizadas
- Iconografía temática espacial
- Transiciones y animaciones suaves
- Manejo robusto de errores
- Validación de datos en múltiples niveles

---

**Desarrollado por**: [Tu Nombre]
**Fecha**: Diciembre 2025
**Curso**: Programación Móvil

---

## 🎉 ¡Práctica Completada Exitosamente!

Todos los requisitos han sido implementados y probados:
- ✅ CRUDs con base de datos dinámica
- ✅ Calendario con table_calendar
- ✅ Dos tablas relacionadas con integridad referencial
- ✅ Dos widgets nuevos personalizados (FlipCard y ParallaxImage)
- ✅ Acceso completo a todas las pantallas Cosmic
