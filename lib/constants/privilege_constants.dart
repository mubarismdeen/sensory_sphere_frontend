const String documentDetailsScreenPrivilege = "documentDetailsScreen";
const String quotationDetailsScreenPrivilege = "quotationDetailsScreen";
const String jobDetailsScreenPrivilege = "jobDetailsScreen";
const String clientDetailsScreenPrivilege = "clientDetailsScreen";

enum Privilege {
  documentDetails,
  quotationDetails,
  jobDetails,
  clientDetails,
}

extension ValueExtension on Privilege {
  String get displayValue {
    switch (this) {
      case Privilege.documentDetails:
        return "Document Details";
      case Privilege.quotationDetails:
        return "Quotation Details";
      case Privilege.jobDetails:
        return "Job Details";
      case Privilege.clientDetails:
        return "Client Details";
    }
  }
}

extension NameExtension on Privilege {
  String get name {
    switch (this) {
      case Privilege.documentDetails:
        return documentDetailsScreenPrivilege;
      case Privilege.quotationDetails:
        return quotationDetailsScreenPrivilege;
      case Privilege.jobDetails:
        return jobDetailsScreenPrivilege;
      case Privilege.clientDetails:
        return clientDetailsScreenPrivilege;
    }
  }
}