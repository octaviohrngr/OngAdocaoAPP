
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FormularioPdfService {
  String _valor(dynamic valor) {
    final texto = (valor ?? '').toString().trim();
    return texto.isEmpty ? 'Não informado' : texto;
  }

  String _status(String status) {
    switch (status) {
      case 'em_analise':
        return 'Em análise';
      case 'finalizado_ok':
        return 'Finalizado OK';
      case 'negado':
        return 'Negado';
      default:
        return 'Não informado';
    }
  }

  String _data(dynamic valor) {
    final data = DateTime.tryParse(
      (valor ?? '').toString(),
    )?.toLocal();

    if (data == null) return 'Não informada';

    String doisDigitos(int numero) =>
        numero.toString().padLeft(2, '0');

    return '${doisDigitos(data.day)}/'
        '${doisDigitos(data.month)}/'
        '${data.year}';
  }

  pw.Widget _campo(String titulo, String valor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            titulo,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            valor,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> baixarFormulario(
      Map<String, dynamic> formulario,
      ) async {
    final pdf = pw.Document();

    final animal = formulario['animalId'] is Map
        ? Map<String, dynamic>.from(
      formulario['animalId'] as Map,
    )
        : <String, dynamic>{};

    final nomeAnimal = _valor(animal['nome']);
    final status = _status(
      (formulario['status'] ?? '').toString(),
    );

    final id = _valor(
      formulario['_id'] ?? formulario['id'],
    );

    // Fonte com suporte a acentos e caracteres Unicode.
    final fonteRegular = await PdfGoogleFonts.notoSansRegular();
    final fonteNegrito = await PdfGoogleFonts.notoSansBold();

    final verde = PdfColor.fromHex('#4A5A1F');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(35),
        theme: pw.ThemeData.withFont(
          base: fonteRegular,
          bold: fonteNegrito,
        ),
        build: (context) => [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: verde,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ATIPATTAS',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Solicitação de Adoção',
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 22),

          pw.Text(
            'Informações da Solicitação',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: verde,
            ),
          ),

          pw.SizedBox(height: 12),

          _campo('Protocolo', id),
          _campo('Animal', nomeAnimal),
          _campo(
            'Data da solicitação',
            _data(formulario['createdAt']),
          ),
          _campo('Status', status),

          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 12),

          pw.Text(
            'Dados do Adotante',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: verde,
            ),
          ),

          pw.SizedBox(height: 12),

          _campo('Nome completo', _valor(formulario['nome'])),
          _campo('E-mail', _valor(formulario['email'])),
          _campo('Telefone', _valor(formulario['telefone'])),

          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 12),

          pw.Text(
            'Sobre a Rotina',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: verde,
            ),
          ),

          pw.SizedBox(height: 12),

          _campo(
            'Tipo de moradia',
            _valor(formulario['tipoMoradia']),
          ),

          _campo(
            'Tempo médio que o animal ficará sozinho',
            _valor(formulario['tempoMedioSozinho']),
          ),

          _campo(
            'Mensagem para o abrigo',
            _valor(formulario['mensagem']),
          ),

          _campo(
            'Termos de adoção responsável',
            formulario['aceitarTermos'] == true
                ? 'Aceitos'
                : 'Não aceitos',
          ),

          pw.SizedBox(height: 25),

          pw.Divider(color: PdfColors.grey300),

          pw.Text(
            'Documento gerado pelo aplicativo ATIPATTAS.',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();

    final nomeArquivo =
        'solicitacao_adocao_${id.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.pdf';

    await Printing.sharePdf(
      bytes: bytes,
      filename: nomeArquivo,
    );
  }
}
