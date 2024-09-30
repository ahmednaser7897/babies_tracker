import 'dart:io';
import 'package:babies_tracker/model/mother_model.dart';
import 'package:babies_tracker/ui/mother/pdfs/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:babies_tracker/app/extensions.dart';

class MotherHealthPdf {
  static Future<File> generate(MotherModel model) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(10),
      build: (context) => [
        buildHeader(model),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        motherHealth(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        motherMedications(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        motherBabys(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(MotherModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText('Genral information'),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          SizedBox(
            height: 15.h,
            child: GridView(
              childAspectRatio: 50.w / 2.h,
              crossAxisCount: 2,
              crossAxisSpacing: 50.w / 2.h,
              children: <Widget>[
                buildText(
                  title: 'Name',
                  value: model.name ?? '',
                ),
                buildText(title: 'Email', value: model.email ?? ''),
                buildText(title: 'phone ', value: model.phone ?? ''),
                buildText(title: 'Address', value: model.address ?? ''),
              ],
            ),
          ),
        ],
      );

  static Widget motherHealth(MotherModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        titleText(
          "Mother Healthy",
        )
      ]),
      SizedBox(height: .5 * PdfPageFormat.cm),
      subTitelText(
        "Healthy History",
      ),
      SizedBox(height: .2 * PdfPageFormat.cm),
      showList(
        model.healthyHistory ?? [],
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      subTitelText(
        "Postpartum Health",
      ),
      SizedBox(height: .2 * PdfPageFormat.cm),
      showList(
        model.postpartumHealth ?? [],
      ),
    ]);
  }

  static Widget showList(List<String> myList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(myList.length, (index) {
        return subTitelText(
          '${index + 1} - ${myList[index]}',
        );
      }),
    );
  }

  static Widget motherMedications(MotherModel model) {
    final headers = [
      'Name',
      'Frequency',
      'Dosage',
      'Start Date',
      'End Date',
    ];
    final List<List<dynamic>> data = [];
    for (var element in model.medications!) {
      data.add([
        element.name,
        element.frequency,
        element.dosage,
        element.startDate.orEmpty().split('-')[0],
        element.endDate.orEmpty().split('-')[0],
      ]);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      titleText(
        'Current medications',
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      TableHelper.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 20,
        columnWidths: {
          0: const FlexColumnWidth(2),
          1: const FlexColumnWidth(1),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(1),
          4: const FlexColumnWidth(1),
        },
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
          4: Alignment.centerRight,
        },
      )
    ]);
  }

  static Widget motherBabys(MotherModel model) {
    final headers = [
      'Name',
      'Bith Date',
      'Weight in(kg)',
      '"Height in(cm)',
    ];
    final List<List<dynamic>> data = [];
    for (var element in model.babys!) {
      data.add([
        element.name,
        element.birthDate,
        element.birthWeight,
        element.birthLength,
      ]);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      titleText(
        'Babys',
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      TableHelper.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        cellAlignment: Alignment.center,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      )
    ]);
  }

  static Text titleText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: const PdfColor.fromInt(0xFFe0185e)),
        textAlign: TextAlign.center);
  }

  static Text subTitelText(String tetx) {
    return Text(
      tetx,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: PdfColors.blueGrey),
    );
  }

  static buildText({
    required String title,
    required String value,
    TextStyle? titleStyle,
  }) {
    final style = titleStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: PdfColors.blueGrey,
        );

    return Text('$title : $value', style: style);
  }
}
