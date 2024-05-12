import 'dart:async';
import 'dart:convert';

import 'package:admin/globalState.dart';
import 'package:admin/models/alarm_details.dart';
import 'package:admin/models/clientDetails.dart';
import 'package:admin/models/employeeDetails.dart';
import 'package:admin/models/jobDetails.dart';
import 'package:admin/models/leaveSalary.dart';
import 'package:admin/models/quotationDetails.dart';
import 'package:admin/models/salaryPaid.dart';
import 'package:admin/models/saveEmployeeDetails.dart';
import 'package:admin/models/userPrivileges.dart';
import 'package:admin/models/userScreens.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;

import 'models/attedanceDto.dart';
import 'models/attendanceModel.dart';
import 'models/docDetails.dart';
import 'models/empMaster.dart';
import 'models/property_details.dart';
import 'models/response_dto.dart';
import 'models/salaryMaster.dart';
import 'models/salaryMasterGet.dart';
import 'models/salaryPay.dart';
import 'models/sensor_data.dart';
import 'models/status_entity.dart';
import 'models/userDetails.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// String ip = "192.168.1.4:8091";   // over network
String ip = "${GlobalState.ipAddress}:8090"; // over network
// String ip = "localhost:8091"; // local

String baseUrl = "http://$ip/api";
String userUrl = "$baseUrl/user";
String dataUrl = "$baseUrl/data";
String alarmsUrl = "$baseUrl/alarms";
String settingsUrl = "$baseUrl/settings";
String propertyUrl = "$baseUrl/property";

enum HttpMethod {
  GET,
  POST,
}

Future<dynamic> httpConnect(String urlWithParams, HttpMethod method,
    [dynamic jsonData]) async {
  dynamic response;
  switch (method) {
    case HttpMethod.GET:
      response = await http.get(Uri.parse(urlWithParams));
      break;
    case HttpMethod.POST:
      response = await http.post(Uri.parse(urlWithParams),
          headers: {"Content-Type": "application/json"}, body: jsonData);
      break;
    default:
      throw Exception('Invalid Http Method');
  }
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  } else if (response.statusCode == 400) {
    return json.decode(response.body);
  } else if (response.statusCode == 401) {
    throw UnauthorizedException();
  } else {
    throw Exception(json.decode(response.body)['message'] ?? 'Failed');
  }
}

Future<bool> localUserValidation(String userID, String password) async {
  if (userID == '1' && password == '123') {
    return true;
  } else {
    return false;
  }
}

Future<UserScreens> authorizeUser(String username, String password) async {
  String urlWithParams =
      "$userUrl/authorizeUser?username=$username&password=$password&firebaseToken=${GlobalState.firebaseToken}";
  UserScreens response =
      UserScreens.fromJson(await httpConnect(urlWithParams, HttpMethod.GET));
  return response;
}

Future<List<UserScreens>> authorizeUserLocally(
    String username, String password) async {
  List<UserScreens> list = [];
  if (username == "admin" && password == "123") {
    UserScreens screens = UserScreens(creatBy: '');
    screens.dashboard = true;
    screens.employees = true;
    screens.attendance = true;
    screens.salaryMaster = true;
    screens.salaryPayout = true;
    screens.leaveSalary = true;
    screens.clients = true;
    screens.gratuity = true;
    screens.alarms = true;
    list.add(screens);
  }
  return list;
}

Future<List<SensorData>> getLastSensorData(String propertyName) async {
  String urlWithParams = "$dataUrl/lastData?propertyName=$propertyName";
  List<SensorData> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => SensorData.fromJson(job))
          .toList();
  return list;
}

Future<List<StatusEntity>> getProperties() async {
  String urlWithParams = "$dataUrl/getProperties";
  List<StatusEntity> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => StatusEntity.fromJson(job))
          .toList();
  return list;
}

Future<List<StatusEntity>> getParameters() async {
  String urlWithParams = "$alarmsUrl/getParameters";
  List<StatusEntity> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => StatusEntity.fromJson(job))
          .toList();
  return list;
}

Future<List<StatusEntity>> getConditions() async {
  String urlWithParams = "$alarmsUrl/getConditions";
  List<StatusEntity> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => StatusEntity.fromJson(job))
          .toList();
  return list;
}

Future<List<StatusEntity>> getStatuses() async {
  String urlWithParams = "$alarmsUrl/getStatuses";
  List<StatusEntity> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => StatusEntity.fromJson(job))
          .toList();
  return list;
}

Future<ResponseDto> triggerMotor(String trigger) async {
  String urlWithParams = "$baseUrl/mqtt/triggerMotor?trigger=$trigger";
  ResponseDto response = ResponseDto.fromJson(
      await httpConnect(urlWithParams, HttpMethod.POST, ""));
  return response;
}

Future<List<PropertyDetails>> getPropertyDetails() async {
  String urlWithParams = "$propertyUrl/getPropertyDetails";
  List<PropertyDetails> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => PropertyDetails.fromJson(job))
          .toList();
  return list;
}

Future<ResponseDto> savePropertyDetails(PropertyDetails alarmDetails) async {
  String urlWithParams = "$propertyUrl/savePropertyDetails";
  var jsonData = jsonEncode(alarmDetails);
  ResponseDto response = ResponseDto.fromJson(
      await httpConnect(urlWithParams, HttpMethod.POST, jsonData));
  return response;
}

Future<List<AlarmDetails>> getAlarmDetails() async {
  String urlWithParams = "$alarmsUrl/getAlarmDetails";
  List<AlarmDetails> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => AlarmDetails.fromJson(job))
          .toList();
  return list;
}

Future<ResponseDto> saveAlarmDetails(AlarmDetails alarmDetails) async {
  String urlWithParams = "$alarmsUrl/saveAlarmDetails";
  var jsonData = jsonEncode(alarmDetails);
  ResponseDto response = ResponseDto.fromJson(
      await httpConnect(urlWithParams, HttpMethod.POST, jsonData));
  return response;
}

Future<ResponseDto> createDatabaseBackup() async {
  String urlWithParams =
      "$settingsUrl/createBackup?username=${GlobalState.username}";
  ResponseDto response =
      ResponseDto.fromJson(await httpConnect(urlWithParams, HttpMethod.GET));
  return response;
}

Future<List<UserDetails>> getUserDetails(String empCode) async {
  String urlWithParams = "http://$ip/Hrms/getUserDetails?empCode=$empCode";
  List<UserDetails> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => UserDetails.fromJson(job))
          .toList();
  return list;
}

Future<List<UserDetails>> getUserDetailsWithUsername(String username) async {
  String urlWithParams =
      "http://$ip/Hrms/getUserDetailsWithUsername?username=$username";
  List<UserDetails> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => UserDetails.fromJson(job))
          .toList();
  return list;
}

Future<bool> saveUserDetails(UserDetails userDetails) async {
  String urlWithParams = "http://$ip/Hrms/saveUserDetails";
  var jsonData = jsonEncode(userDetails);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<List<UserScreens>> getScreensForEmployee(String empCode) async {
  String urlWithParams =
      "http://$ip/Hrms/getScreensForEmployee?empCode=$empCode";
  List<UserScreens> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => UserScreens.fromJson(job))
          .toList();
  return list;
}

Future<bool> saveScreensForEmployee(UserScreens userScreens) async {
  String urlWithParams = "http://$ip/Hrms/saveScreensForEmployee";
  var jsonData = jsonEncode(userScreens);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<List<UserPrivileges>> getAllPrivilegesForUser(String empCode) async {
  String urlWithParams =
      "http://$ip/Hrms/getAllPrivilegesForUser?empCode=$empCode";
  List<UserPrivileges> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => UserPrivileges.fromJson(job))
          .toList();
  return list;
}

Future<List<UserPrivileges>> getAPrivilegeForUser(
    String username, String privilegeName) async {
  String urlWithParams =
      "http://$ip/Hrms/getAPrivilegeForUser?userName=$username&privilege=$privilegeName";
  List<UserPrivileges> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => UserPrivileges.fromJson(job))
          .toList();
  return list;
}

Future<bool> savePrivilegesForUser(List<UserPrivileges> privilegesList) async {
  String urlWithParams = "http://$ip/Hrms/savePrivilegesForUser";
  var jsonData = jsonEncode(privilegesList);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<List<Map<String, dynamic>>> getDocDetails() async {
  String urlWithParams = "http://$ip/Hrms/getDocDetails";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getDocType() async {
  String urlWithParams = "http://$ip/Hrms/getDocType";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getQuotationType() async {
  String urlWithParams = "http://$ip/Hrms/getQuotationType";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getPoStatus() async {
  String urlWithParams = "http://$ip/Hrms/getpoStatus";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getInvoiceStatus() async {
  String urlWithParams = "http://$ip/Hrms/getinvStatus";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getQuotationDetails(String clientName,
    String name, String poStatus, String invStatus, String type) async {
  String urlWithParams =
      "http://$ip/Hrms/getQuotationDetails?clientName=$clientName&name=$name&poStatus=$poStatus&invStatus=$invStatus&type=$type";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<bool> deleteQuotationDetails(int quotationId) async {
  String urlWithParams =
      "http://$ip/Hrms/DeleteQuotationDetails?id=$quotationId";
  return await httpConnect(urlWithParams, HttpMethod.GET) as bool;
}

Future<List<Map<String, dynamic>>> getGratuityDetails() async {
  String urlWithParams = "http://$ip/Hrms/getGratuityDetails";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<bool> saveSalaryMaster(SalaryMaster salaryMaster) async {
  String urlWithParams = "http://$ip/Hrms/saveSalaryMaster";
  var jsonData = jsonEncode(salaryMaster);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<bool> deleteSalaryMaster(int salaryMasterId) async {
  String urlWithParams =
      "http://$ip/Hrms/DeleteSalaryMaster?id=$salaryMasterId";
  return await httpConnect(urlWithParams, HttpMethod.GET) as bool;
}

Future<bool> saveDocDetails(DocDetails docDetails) async {
  String urlWithParams = "http://$ip/Hrms/saveDocDetails";
  var jsonData = jsonEncode(docDetails);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<bool> deleteDocDetails(int docId) async {
  String urlWithParams = "http://$ip/Hrms/DeleteDocDetails?id=$docId";
  return await httpConnect(urlWithParams, HttpMethod.GET) as bool;
}

Future<bool> saveQuotationDetails(QuotationDetails quotationDetails) async {
  String urlWithParams = "http://$ip/Hrms/saveQuotation";
  var jsonData = jsonEncode(quotationDetails);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<bool> saveGratuity(String empCode, String type, String editBy) async {
  String urlWithParams =
      "http://$ip/Hrms/SaveGratuity?empCode=$empCode&type=$type&editBy=$editBy";
  return await httpConnect(urlWithParams, HttpMethod.GET) as bool;
}

Future<String> saveAttendance(List<AttendanceModel> attendanceList) async {
  String urlWithParams = "http://$ip/Hrms/saveAttendance";
  var jsonData = jsonEncode(attendanceList);
  try {
    http.Response response = await http.post(Uri.parse(urlWithParams),
        headers: {"Content-Type": "application/json"}, body: jsonData);
    if (response.statusCode == 200) {
      return response.body;
    }
  } catch (e) {
    throw Exception('Failed');
  }
  return "Failed";
}

Future<List<EmpMaster>> getEmpDetails() async {
  String urlWithParams = "http://$ip/Hrms/getEmpDetails";
  List<EmpMaster> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => EmpMaster.fromJson(job))
          .toList();
  return list;
}

Future<List<EmpMaster>> getGratuityEmp() async {
  String urlWithParams = "http://$ip/Hrms/getGratuityEmp";
  List<EmpMaster> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((job) => EmpMaster.fromJson(job))
          .toList();
  return list;
}

Future<List<AttendanceDto>> getAttendanceDetails(String date) async {
  String urlWithParams = "http://$ip/Hrms/getAttendance?date=$date";
  List<AttendanceDto> list = (await httpConnect(urlWithParams, HttpMethod.GET))
      .map((job) => AttendanceDto.fromJson(job))
      .cast<AttendanceDto>()
      .toList();
  return list;
}

Future<List<SalaryPay>> getSalaryPay(String date) async {
  String urlWithParams = "http://$ip/Hrms/getSalaryPay?date=$date";
  List<SalaryPay> list = (await httpConnect(urlWithParams, HttpMethod.GET))
      .map((job) => SalaryPay.fromJson(job))
      .cast<SalaryPay>()
      .toList();
  return list;
}

Future<List<SalaryMasterGet>> getSalaryMaster(String date) async {
  String urlWithParams = "http://$ip/Hrms/getSalary?date=$date";
  List<SalaryMasterGet> list =
      (await httpConnect(urlWithParams, HttpMethod.GET))
          .map((job) => SalaryMasterGet.fromJson(job))
          .cast<SalaryMasterGet>()
          .toList();
  return list;
}

Future<List<EmployeeDetails>> getEmployeeDetails() async {
  String urlWithParams = "http://$ip/Hrms/getEmployeeDetails";
  List<EmployeeDetails> list =
      (await httpConnect(urlWithParams, HttpMethod.GET))
          .map((job) => EmployeeDetails.fromJson(job))
          .cast<EmployeeDetails>()
          .toList();
  return list;
}

Future<List<LeaveSalary>> getLeaveSalary(String year) async {
  String urlWithParams = "http://$ip/Hrms/getLeaveSalary?year=$year";
  List<LeaveSalary> list = (await httpConnect(urlWithParams, HttpMethod.GET))
      .map((job) => LeaveSalary.fromJson(job))
      .cast<LeaveSalary>()
      .toList();
  return list;
}

Future<bool> saveSalaryPaid(SalaryPaid salaryPaid) async {
  String urlWithParams = "http://$ip/Hrms/saveSalaryPaid";
  var jsonData = jsonEncode(salaryPaid);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<List<Map<String, dynamic>>> getJobDetails(
    String jobStatus, String assignedTo, String dueDate) async {
  String urlWithParams =
      "http://$ip/Hrms/getJobDetails?JobStatus=$jobStatus&AssignedTo=$assignedTo&DueDate=$dueDate";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<bool> saveJobDetails(JobDetails jobDetails) async {
  String urlWithParams = "http://$ip/Hrms/saveJobDetail";
  var jsonData = jsonEncode(jobDetails);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<bool> deleteJobDetails(int jobId) async {
  String urlWithParams = "http://$ip/Hrms/DeleteJobDetails?id=$jobId";
  return await httpConnect(urlWithParams, HttpMethod.GET) as bool;
}

Future<bool> saveEmployeeDetails(SaveEmployeeDetails employeeDetails) async {
  String urlWithParams = "http://$ip/Hrms/saveEmployeeDetails";
  var jsonData = jsonEncode(employeeDetails);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<bool> deleteEmployeeDetails(int employeeId) async {
  String urlWithParams = "http://$ip/Hrms/DeleteEmployeeDetails?id=$employeeId";
  return await httpConnect(urlWithParams, HttpMethod.GET) as bool;
}

Future<List<Map<String, dynamic>>> getJobStatuses() async {
  String urlWithParams = "http://$ip/Hrms/getjobStatus";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getDepartments() async {
  String urlWithParams = "http://$ip/Hrms/getDeparments";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getEmployeeStatuses() async {
  String urlWithParams = "http://$ip/Hrms/getEmployeeStatuses";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getEmployeeNationalities() async {
  String urlWithParams = "http://$ip/Hrms/getEmployeeNationalities";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<Map<String, dynamic>>> getGratuityType() async {
  String urlWithParams = "http://$ip/Hrms/getGratuityType";
  List<Map<String, dynamic>> list =
      (await httpConnect(urlWithParams, HttpMethod.GET) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
  return list;
}

Future<List<ClientDetails>> getClientDetails() async {
  String urlWithParams = "http://$ip/Hrms/getClientDetails";
  List<ClientDetails> list = (await httpConnect(urlWithParams, HttpMethod.GET))
      .map((job) => ClientDetails.fromJson(job))
      .cast<ClientDetails>()
      .toList();
  return list;
}

Future<bool> saveClientDetails(ClientDetails clientDetails) async {
  String urlWithParams = "http://$ip/Hrms/saveClientDetails";
  var jsonData = jsonEncode(clientDetails);
  return await httpConnect(urlWithParams, HttpMethod.POST, jsonData) as bool;
}

Future<bool> deleteClientDetails(int clientId) async {
  String urlWithParams = "http://$ip/Hrms/DeleteClientDetails?id=$clientId";
  return await httpConnect(urlWithParams, HttpMethod.GET) as bool;
}
