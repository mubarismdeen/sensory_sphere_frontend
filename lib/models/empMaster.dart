class EmpMaster {
  int id = 0;
  String empCode = "";
  String name = "";
  String mobile1 = "";
  String mobile2 = "";
  int depId = 0;
  int statusId = 0;
  int nationalityId = 0;
  DateTime joinDt = DateTime.now();
  DateTime birthDt = DateTime.now();
  String editBy = '';
  DateTime editDate = DateTime.now();
  String creatBy = '';
  DateTime creatDate = DateTime.now();

  EmpMaster({
    required this.id,
    required this.empCode,
    required this.name,
    required this.mobile1,
    required this.mobile2,
    required this.depId,
    required this.statusId,
    required this.nationalityId,
    required this.joinDt,
    required this.birthDt,
    required this.editBy,
    required this.editDate,
    required this.creatBy,
    required this.creatDate,
  });

  Map<String, dynamic> toJson() =>
  {
    'id' :id,
    'empCode' :empCode,
    'name' :name ,
    'mobile1' :mobile1 ,
    'mobile2' :mobile2 ,
    'depId' :depId ,
    'statusId' :statusId ,
    'nationalityId' :nationalityId ,
    'joinDt' :joinDt.toIso8601String() ,
    'birthDt' :birthDt.toIso8601String() ,
    'editBy' :editBy ,
    'editDate' :editDate.toIso8601String() ,
    'creatBy' :creatBy ,
    'creatDate' :creatDate.toIso8601String(),
  };

     EmpMaster.fromJson(Map<String, dynamic> json) {
        id =  json['id']??"0";
        empCode =  json['empCode']??"";
        name =  json['name']??"";
        mobile1 =  json['mobile1']??"";
        mobile2 =  json['mobile2']??"";
        depId =  json['depId']??"";
        statusId =  json['statusId']??"";
        nationalityId =  json['nationalityId']??0;
        joinDt =  DateTime.parse(json['joinDt']??DateTime.now());
        birthDt =  DateTime.parse(json['birthDt']??DateTime.now());
        editBy =  json['editBy']??"";
        editDate =  DateTime.parse(json['editDate']??DateTime.now());
        creatBy =  json['creatBy']??"";
        creatDate =  DateTime.parse(json['creatDate']??DateTime.now());
    }

  }
