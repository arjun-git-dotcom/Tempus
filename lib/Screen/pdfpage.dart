import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_project/Design/colors.dart';
import 'package:hive_project/Design/gradient.dart';
import 'package:hive_project/db/pdf.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive_project/db/eventmodel.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PdfPage> {
  late Box<PDFDocument> _pdfBox;
  Box<Event>? calenderbox;
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _pdfBox = await Hive.openBox<PDFDocument>('pdf_box');
    calenderbox = await Hive.box<Event>('calenderbox');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black(),
        title: Center(
          child: Text(
            'Pdf Shelf',
            style: TextStyle(color: AppColors.white()),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final String? result = await showSearch(
                context: context,
                delegate: PdfSearchDelegate(_pdfBox, calenderbox),
              );
              if (result != null) {
                setState(() {
                  _searchText = result;
                });
              }
            },
            icon:  Icon(Icons.search,color: AppColors.white(),),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfBox.isEmpty
              ? Container(decoration: BoxDecoration(gradient: AppGradient.calenderGradient()),       child: const Center(child: Text('No PDF documents found')))
              : Container(
                  decoration:
                      BoxDecoration(gradient: AppGradient.calenderGradient()),
                  child: ListView.builder(
                    itemCount: _pdfBox.length,
                    itemBuilder: (context, index) {
                      final document = _pdfBox.getAt(index)!;
                   
    
                      if (_searchText.isNotEmpty &&
                          !document.name
                              .toLowerCase()
                              .contains(_searchText.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
    
                      return ListTile(
                        title: Text(
                          
                               " ${document.name}",
                           
                          style: TextStyle(color: AppColors.blue()),
                        ),
                        onTap: () => _openPDF(document.path),
                      );
                    },
                  ),
                ),
    );
  }

  void _openPDF(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PDFView(filePath: path)),
    );
  }
}

class PdfSearchDelegate extends SearchDelegate<String> {
  final Box<PDFDocument> pdfBox;
  final Box<Event>? calenderbox;

  PdfSearchDelegate(this.pdfBox, this.calenderbox);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final allDocuments = pdfBox.values.toList().cast<PDFDocument>();

    final suggestions = query.isEmpty
        ? allDocuments.map((doc) => doc.name).toList()
        : allDocuments
            .where(
                (doc) => doc.name.toLowerCase().startsWith(query.toLowerCase()))
            .map((doc) => doc.name)
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text( suggestion),
          onTap: () {
            query = suggestion;
            close(context, query);
          },
        );
      },
    );
  }
}
