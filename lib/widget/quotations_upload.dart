import 'package:admin/globalState.dart';
import 'package:admin/models/quotationDetails.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api.dart';
import '../models/clientDetails.dart';
import '../utils/common_utils.dart';

class QuotationsUpload extends StatefulWidget {
  dynamic closeDialog;
  Map<String, dynamic>? tableRow;
  UserPrivileges privileges;

  QuotationsUpload(this.closeDialog, this.tableRow, this.privileges);

  @override
  State<QuotationsUpload> createState() => _QuotationsUploadState();
}

class _QuotationsUploadState extends State<QuotationsUpload> {
  final _formKey = GlobalKey<FormState>();

  var _name = TextEditingController();
  var _narration = TextEditingController();
  var _invocieNo = TextEditingController();
  var _poNo = TextEditingController();
  var _poRefNo = TextEditingController();
  var _reportNo = TextEditingController();
  var _invoiceAmt = TextEditingController();
  var _dueDate = TextEditingController();
  late Map<String, dynamic> _selectedInvStatus;
  late Map<String, dynamic> _selectedPoStatus;
  late Map<String, dynamic> _selectedType;
  late ClientDetails _selectedClient;
  String? _clientName;
  String? _type;
  String? _invStatus;
  String? _poStatus;

  List<Map<String, dynamic>> invoiceStatuses = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> poStatuses = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> types = <Map<String, dynamic>>[];
  List<ClientDetails> clients = <ClientDetails>[];

  getDropdownInputs() async {
    invoiceStatuses = await getInvoiceStatus();
    poStatuses = await getPoStatus();
    types = await getQuotationType();
    clients = await getClientDetails();
    if (widget.tableRow != null) {
      setValue();
    }
  }

  setValue() {
    _quotationDetails.id = widget.tableRow!['id'];
    _name.text = widget.tableRow!['name'].toString();
    _narration.text = widget.tableRow!['narration'].toString();
    _invocieNo.text = widget.tableRow!['invoiceNo'].toString();
    _poNo.text = widget.tableRow!['poNo'].toString();
    _poRefNo.text = widget.tableRow!['poRefNo'].toString();
    _reportNo.text = widget.tableRow!['reportNo'].toString();
    _invoiceAmt.text = widget.tableRow!['invoiceAmt'].toString();
    _dueDate.text = widget.tableRow!['dueDate'];
    _invStatus = widget.tableRow!['invStatus'];
    _poStatus = widget.tableRow!['poStatus'];
    _type = widget.tableRow!['type'];
    _clientName = widget.tableRow!['clientName'];

    _selectedInvStatus = invoiceStatuses
        .firstWhere((invStatus) => invStatus['description'] == _invStatus);
    _selectedPoStatus = poStatuses
        .firstWhere((poStatus) => poStatus['description'] == _poStatus);
    _selectedType = types.firstWhere((type) => type['description'] == _type);
    _selectedClient =
        clients.firstWhere((client) => client.name == _clientName);
  }

  QuotationDetails _quotationDetails = QuotationDetails(
      id: 0,
      clientId: 0,
      narration: "",
      name: "",
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      invoiceNo: 0,
      invoiceAmt: 0,
      poNo: 0,
      poRefNo: 0,
      reportNo: 0,
      poStatus: 0,
      invStatus: 0,
      type: 0,
      dueDate: "",
      creatBy: GlobalState.userEmpCode,
      creatDt: DateTime.now(),
      editBy: GlobalState.userEmpCode,
      editDt: DateTime.now());

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      // Submit the form data to a backend API or do something else with it
      print('Submitted form data:');
      print('Client Name: ${_selectedClient.id}');
      print('Name: $_name');
      print('Narration: $_narration');
      print('Invoice No: $_invocieNo');
      print('PO Status: ${_selectedPoStatus['id']}');
      print('Invoice Status: ${_selectedInvStatus['id']}');
      print('Type: ${_selectedType['id']}');
      print('Due Date: $_dueDate');
    }
    _quotationDetails.clientId = _selectedClient.id;
    _quotationDetails.name = _name.text;
    _quotationDetails.narration = _narration.text;
    _quotationDetails.invoiceNo = int.parse(_invocieNo.text);
    _quotationDetails.poNo = int.parse(_poNo.text);
    _quotationDetails.poRefNo = int.parse(_poRefNo.text);
    _quotationDetails.reportNo = int.parse(_reportNo.text);
    _quotationDetails.invoiceAmt = double.parse(_invoiceAmt.text);
    _quotationDetails.poStatus = _selectedPoStatus['id'];
    _quotationDetails.invStatus = _selectedInvStatus['id'];
    _quotationDetails.type = _selectedType['id'];
    _quotationDetails.dueDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(_dueDate.text));

    bool status = await saveQuotationDetails(_quotationDetails);
    if (status) {
      showSaveSuccessfulMessage(context);
      _name.clear();
      Navigator.pop(context);
      widget.closeDialog();
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
  }

  Future<void> _onDelete() async {
    bool status = await deleteQuotationDetails(_quotationDetails.id);
    if (status) {
      showSaveSuccessfulMessage(context);
      Navigator.pop(context);
      widget.closeDialog();
      setState(() {});
    } else {
      showSaveFailedMessage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getDropdownInputs(),
        builder: (context, AsyncSnapshot<dynamic> _data) {
          if (_data.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
                    width: 25, height: 25, child: CircularProgressIndicator()));
          } else if (_data.hasError) {
            return Text('Error: ${_data.error}');
          } else {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select client';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Client'),
                      items: clients.map<DropdownMenuItem<String>>(
                          (ClientDetails client) {
                        return DropdownMenuItem<String>(
                          value: client.name,
                          child: Text(client.name),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        _selectedClient = clients
                            .firstWhere((client) => client.name == value);
                        //   setState(() {
                        // });
                      },
                      value: _clientName,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'vessel'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter vessel';
                        }
                        return null;
                      },
                      controller: _name,
                      onSaved: (value) {},
                    ),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select quotation type';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Quotation Type'),
                      items:
                          types.map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['description'].toString(),
                          child: Text(value['description']),
                        );
                      }).toList(),
                      onChanged: (String? t) {
                        _selectedType = types
                            .firstWhere((type) => type['description'] == t);
                        //   setState(() {
                        // });
                      },
                      value: _type,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Narration'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter narration';
                        }
                        return null;
                      },
                      controller: _narration,
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Report Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Report number';
                        }
                        return null;
                      },
                      controller: _reportNo,
                      onSaved: (value) {},
                    ),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select PO status';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'PO Status'),
                      items: poStatuses
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['description'].toString(),
                          child: Text(value['description']),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        _selectedPoStatus = poStatuses.firstWhere(
                            (poStatus) => poStatus['description'] == value);
                      },
                      value: _poStatus,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'PO Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter invoice number';
                        }
                        return null;
                      },
                      controller: _poNo,
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'PO Ref Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter invoice number';
                        }
                        return null;
                      },
                      controller: _poRefNo,
                      onSaved: (value) {},
                    ),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select invoice status';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Invoice Status'),
                      items: invoiceStatuses
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['description'].toString(),
                          child: Text(value['description']),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        _selectedInvStatus = invoiceStatuses.firstWhere(
                            (invStatus) => invStatus['description'] == value);
                      },
                      value: _invStatus,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Invoice Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter invoice number';
                        }
                        return null;
                      },
                      controller: _invocieNo,
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Invoice Amount'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter invoice Amount';
                        }
                        return null;
                      },
                      controller: _invoiceAmt,
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      controller: _dueDate,
                      decoration: const InputDecoration(labelText: 'Due Date'),
                      onTap: () async {
                        DateTime? date = DateTime(1900);
                        FocusScope.of(context).requestFocus(FocusNode());
                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          _dueDate.text = DateFormat('yyyy-MM-dd').format(date);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select Due Date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ...getActionButtonsWithPrivilege(
                            context: context,
                            privileges: widget.privileges,
                            hasData: widget.tableRow != null,
                            onSubmit: _onSubmit,
                            onDelete: _onDelete),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
