import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CLON MIUPC',
      theme: ThemeData(
        primarySwatch: Colors.red,
        // Usamos la fuente del sistema que más se asemeja al renderizado de la captura
        fontFamily: 'sans-serif-condensed',
      ),
      home: const MenuScreen(),
    );
  }
}

// ================= PANTALLA 1: MENÚ DE CONFIGURACIÓN =================
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _nameController = TextEditingController(text: "RAFAEL AUGUSTO");
  final _lastNameController = TextEditingController(text: "TERRONES ALTAMIRANO");
  final _codeController = TextEditingController(text: "20231F226");
  final _bannerController = TextEditingController(text: "N04432887");
  String _selectedCarrera = "INGENIERÍA DE SOFTWARE";
  String _selectedCampus = "Campus Monterrico";
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      if (!mounted) return;
      final croppedBytes = await Navigator.push<Uint8List>(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropScreen(imageBytes: bytes),
        ),
      );
      if (croppedBytes != null) {
        setState(() {
          _imageBytes = croppedBytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurar Datos TIU',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF151B54),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFFE2E5EC),
                backgroundImage: _imageBytes != null
                    ? MemoryImage(_imageBytes!)
                    : null,
                child: _imageBytes == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            if (_imageBytes != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _imageBytes = null;
                  });
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('Remover foto', style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 8),
            ] else ...[
              const SizedBox(height: 25),
            ],
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombres',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellidos',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Código de Alumno'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bannerController,
              decoration: const InputDecoration(labelText: 'ID Banner'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCarrera,
              items:
                  [
                    "INGENIERÍA DE SOFTWARE",
                    "INGENIERÍA DE SISTEMAS",
                    "INGENIERÍA CIVIL",
                    "ADMINISTRACIÓN",
                    "DERECHO",
                    "DISEÑO GRÁFICO",
                    "ARQUITECTURA",
                    "MEDICINA",
                    "COMUNICACIÓN Y PUBLICIDAD",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (val) => setState(() => _selectedCarrera = val!),
              decoration: const InputDecoration(labelText: 'Carrera'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCampus,
              items:
                  [
                    "Campus Monterrico",
                    "Campus San Isidro",
                    "Campus San Miguel",
                    "Campus Villa",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (val) => setState(() => _selectedCampus = val!),
              decoration: const InputDecoration(labelText: 'Campus'),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF151B54),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final String surnames = _lastNameController.text.trim();
                String formattedSurnames = '';
                if (surnames.isNotEmpty) {
                  final parts = surnames.split(RegExp(r'\s+'));
                  formattedSurnames = parts.map((part) {
                    if (part.isEmpty) return '';
                    return '${part[0].toUpperCase()}***';
                  }).join(' ');
                }
                
                final String fullName = '${_nameController.text.trim().toUpperCase()} $formattedSurnames'.trim();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TiuScreen(
                      name: fullName,
                      code: _codeController.text,
                      banner: _bannerController.text,
                      carrera: _selectedCarrera,
                      campus: _selectedCampus,
                      imageBytes: _imageBytes,
                    ),
                  ),
                );
              },
              child: const Text(
                'Generar TIU Virtual',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PANTALLA 2: RÉPLICA EXACTA TIU =================
class TiuScreen extends StatefulWidget {
  final String name;
  final String code;
  final String banner;
  final String carrera;
  final String campus;
  final Uint8List? imageBytes;

  const TiuScreen({
    super.key,
    required this.name,
    required this.code,
    required this.banner,
    required this.carrera,
    required this.campus,
    this.imageBytes,
  });

  @override
  State<TiuScreen> createState() => _TiuScreenState();
}

class _TiuScreenState extends State<TiuScreen> {
  late String _timeString;
  late String _dateString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now(), 'HH:mm:ss');
    _dateString = _formatDateTime(DateTime.now(), 'EEEE, d MMM yyyy');
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = _formatDateTime(now, 'HH:mm:ss');
      _dateString = _formatDateTime(now, 'EEEE, d MMM yyyy');
    });
  }

  String _formatDateTime(DateTime dateTime, String format) {
    String formatted = DateFormat(format, 'es_ES').format(dateTime);
    // Capitalizar primera letra
    formatted = formatted[0].toUpperCase() + formatted.substring(1);
    // Capitalizar la primera letra del mes (después de la coma y el día)
    final commaIndex = formatted.indexOf(', ');
    if (commaIndex != -1 && format.contains('MMM')) {
      // Buscar la abreviatura del mes (después del número del día)
      final afterComma = formatted.substring(commaIndex + 2);
      final parts = afterComma.split(' ');
      if (parts.length >= 3) {
        // parts[0] = día número, parts[1] = mes abreviado, parts[2] = año
        parts[1] = parts[1][0].toUpperCase() + parts[1].substring(1);
        formatted = formatted.substring(0, commaIndex + 2) + parts.join(' ');
      }
    }
    return formatted.replaceAll('.', '');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white),
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F3F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFFFF1111),
              size: 22,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'TIU VIRTUAL',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'SolanoGothicMVB',
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: const Color(0xFFE2E8F0), height: 1.0),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double totalHeight = constraints.maxHeight;
            // Tamaño de avatar responsivo (máximo 180, mínimo 130)
            final double avatarSize = (totalHeight * 0.24).clamp(130.0, 180.0);
            // Posición dinámica según la altura
            final double avatarTop = totalHeight * 0.14;
            // Distancia de la tarjeta proporcional
            final double cardTop = avatarTop + avatarSize + (totalHeight * 0.04);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // ===== FONDO CON NUBES (imagen) =====
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/watermarked_img_5289662645621760062.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),

                // ===== TARJETA BLANCA FLOTANTE =====
                Positioned(
                  left: 24,
                  right: 24,
                  top: cardTop,
                  bottom: totalHeight * 0.05, // Margen inferior dinámico
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.04 * 255).round()),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 20,
                      right: 20,
                      bottom: 24,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Nombre en rojo
                          Text(
                            widget.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                            color: Color(0xFFFF1111),
                            fontSize: 38,
                              fontFamily: 'SolanoGothicMVB',
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Código de alumno
                          const Text(
                            'Código de alumno:',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Godfrey',
                              color: Color(0xFF535969),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.code,
                            style: const TextStyle(
                              fontSize: 21,
                              fontFamily: 'Godfrey',
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF535969),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // ID Banner
                          const Text(
                            'ID Banner:',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Godfrey',
                              color: Color(0xFF535969),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.banner,
                            style: const TextStyle(
                              fontSize: 21,
                              fontFamily: 'Godfrey',
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF535969),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Carrera
                          Text(
                            widget.carrera,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Godfrey',
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF535969),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Campus con ícono
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('📍', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                widget.campus,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Godfrey',
                                  color: Color(0xFF535969),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ===== RELOJ Y FECHA =====
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Caja del reloj
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFDBD9FF,
                          ).withAlpha((0.85 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _timeString,
                          style: const TextStyle(
                            fontSize: 40,
                            fontFamily: 'NimbusSans',
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            letterSpacing: -2.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Fecha
                      Text(
                        _dateString,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Godfrey',
                          color: Color(0xFF535969),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== AVATAR (sobresale la tarjeta) =====
                Positioned(
                  top: avatarTop,
                  left: (constraints.maxWidth - avatarSize) / 2,
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE5E7EB),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.06 * 255).round()),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: widget.imageBytes != null
                          ? Image.memory(
                              widget.imageBytes!,
                              fit: BoxFit.cover,
                              width: avatarSize,
                              height: avatarSize,
                            )
                          : Transform.scale(
                              scale: 1.45,
                              child: Image.asset(
                                'assets/images/default_avatar.jpg',
                                fit: BoxFit.cover,
                                width: avatarSize,
                                height: avatarSize,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ImageCropScreen extends StatefulWidget {
  final Uint8List imageBytes;
  const ImageCropScreen({super.key, required this.imageBytes});

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _cropImage() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        if (!mounted) return;
        Navigator.pop(context, byteData.buffer.asUint8List());
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Encuadrar Foto"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green, size: 30),
            onPressed: _cropImage,
          )
        ],
      ),
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            clipBehavior: Clip.antiAlias,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 8.0,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: Image.memory(
                widget.imageBytes,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
