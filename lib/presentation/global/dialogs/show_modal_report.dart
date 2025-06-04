import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ShowModalReport extends StatefulWidget {
  // final String reportTitle;
  // final String reportDetails;
  final List<Map<String, dynamic>> tableData;
  final String dateFromFilter; // Fecha desde el filtro
  final double timeProm; // Tiempo Promedio de Atención
  ShowModalReport({required this.tableData,required this.dateFromFilter,required this.timeProm});

  @override
  State<ShowModalReport> createState() => _ShowModalReportState();
}

class _ShowModalReportState extends State<ShowModalReport> {
  final GlobalKey _pieChartKey = GlobalKey();
  // Para el gráfico de pastel
  final GlobalKey _barChartKey = GlobalKey();
  // Para el gráfico de barras
  @override
  Widget build(BuildContext context) {

    // Preparar los datos para los gráficos
    final pieChartData = _preparePieChartData(widget.timeProm);
    //final barChartData = _prepareBarChartData();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reporte de Indicadores",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Detalles del Reporte",
            style: TextStyle(fontSize: 16),
          ),
          Text(  "Fecha de Evaluación: ${widget.dateFromFilter.isEmpty ? 'Todas las fechas' : widget.dateFromFilter}",),
          // Text("Fecha del Historial de Evaluación: $dateFromFilter"),
          Text("Tasa de Aciertos: 0.89% - 0.92%"),
          SizedBox(height: 16),
          // Gráfico de Pastel
          Expanded(
            child: Column(
              children: [
                Text('Tiempo Promedio de Detección'),
                Expanded(
                  child: RepaintBoundary(
                    key: _pieChartKey,
                    child: SfCircularChart(
                      // title: ChartTitle(text: 'Distribución de Resultados'),
                      legend: Legend(isVisible: true),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                          dataSource: pieChartData,
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.value,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Espacio entre los gráficos
          // Gráfico de Barras
          Expanded(
            child: Column(
              children: [
                Text('Cantidad de Resultados por Atención'),
                /*Expanded(
                  child: RepaintBoundary(
                    key: _barChartKey,
                    child: SfCartesianChart(
                      // title: ChartTitle(text: 'Cantidad de Resultados por Tipo'),
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                          //dataSource: barChartData,
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.value,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                onPressed: ()async{
                  // await Future.delayed(Duration(milliseconds: 500));
                  await _generatePdf(context);
                },
                icon: Icon(Icons.picture_as_pdf),
              ),
              Text("Generar PDF"),

              SizedBox(width: 30,),
              IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
              ),
              Text("Cerrar"),
            ],
          )
        ],
      ),
    );
  }

  // Preparar los datos para el gráfico de pastel
  List<ChartData> _preparePieChartData(double timeProm) {
    const controlGroupTime = 23966.7; // Convertir a double
    const experimentalGroupTime = 16.5; // Ya es double

    return [
      ChartData('Sistema', timeProm <= experimentalGroupTime ? timeProm : experimentalGroupTime),
      ChartData('Normal', timeProm > controlGroupTime ? timeProm : controlGroupTime),
    ];
  }

  // Preparar los datos para el gráfico de barras
  /*List<ChartData> _prepareBarChartData() {
    final Map<String, int> resultCounts = {'Atendido': widget.countYes, 'No Atendido': widget.countNotNecessary};

    // for (var row in widget.tableData) {
    //   final atendido = row['seAtendio'] == 'Sí' ? 'Atendido' : 'No Atendido';
    //   resultCounts[atendido] = (resultCounts[atendido] ?? 0) + 1;
    // }

    return resultCounts.entries
        .map((entry) => ChartData(entry.key, entry.value.toDouble()))
        .toList();
  }*/

  // Future<void> _generatePdf(BuildContext context) async {
  Future<void> _generatePdf(BuildContext context) async {
    final pieChartImage = await _captureWidgetAsImage(_pieChartKey);
    final barChartImage = await _captureWidgetAsImage(_barChartKey);

    if (pieChartImage == null || barChartImage == null) {
      print('Algunos gráficos no se pudieron capturar. Asegúrate de que están visibles en pantalla.');
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Reporte de Indicadores",
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Fecha de Evaluación: ${widget.dateFromFilter.isEmpty ? 'Todas las fechas' : widget.dateFromFilter}"),
              pw.Text("Tasa de Aciertos: 0.89 % - 0.92 %"),
              pw.SizedBox(height: 16),

              // Incluir el gráfico de pastel
              pw.Text("Tiempo Promedio de Atención:"),
              pw.SizedBox(height: 10),
              pieChartImage != null
                  ? pw.Image(pw.MemoryImage(pieChartImage), height: 200)
                  : pw.Text("Gráfico no disponible"),

              pw.SizedBox(height: 16),

              // Incluir el gráfico de barras
              pw.Text("Pacientes Con Resultado:"),
              pw.SizedBox(height: 10),
              barChartImage != null
                  ? pw.Image(pw.MemoryImage(barChartImage), height: 200)
                  : pw.Text("Gráfico no disponible"),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'reporte_indicadores.pdf');
  }

  Future<Uint8List?> _captureWidgetAsImage(GlobalKey key) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      } else {
        print('No se encontró RenderRepaintBoundary.');
      }
    } catch (e) {
      print('Error al capturar el gráfico: $e');
    }
    return null;
  }
}


// Clase ChartData
class ChartData {
  ChartData(this.category, this.value);
  final String category;
  final double value;
}