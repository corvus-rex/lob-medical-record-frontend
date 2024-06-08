import 'package:flutter/material.dart';

const String BASE_URL = 'http://localhost:8000';
class PatientData {
  static const username = "adrianovpatient";
  static const userType = 4;
  static const userEmail = "adrianovpatient@gmail.com";
  static const name = "Adrian";
  static final dob = DateTime(1985, 5, 15);
  static const nationalID = "10101011010";
  static const phoneNum = "3010110101010";
  static const address = "ABC Street 1010";
  static const alias = "Adrian";
  static const relativePhone = "1010101010";
  static const insurance = {"insurance_id": "91010101001-10110-101010", "insurance_name": "BPJS"};
  static const sex = true;

  static Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userType': userType,
      'userEmail': userEmail,
      'name': name,
      'dob': dob.toIso8601String(),
      'nationalID': nationalID,
      'phoneNum': phoneNum,
      'address': address,
      'alias': alias,
      'relativePhone': relativePhone,
      'insurance': insurance,
      'sex': sex,
    };
  }
}

class DoctorData {
  static const username = "adrianovdoctor";
  static const userType = 2;
  static const userEmail = "adrianovdoctor@gmail.com";
  static const name = "Adrian";
  static final dob = DateTime(1985, 5, 15);
  static const pob = "Bandung";
  static const sex = true;
  static const nationalID = "10101011010";
  static const licenseNum = "191991919";
  static const phoneNum = "3010110101010";
  static const taxNum = "191991919";
  static const address = "ABC Street 1010";
  static const historical = {
    "education": ["Universitas Gadjah Mada - 2024", "Universitas Gadjah Mada - 2018"],
    "experience": ["RS Sardjito - 2024"]
  };

  static Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userType': userType,
      'userEmail': userEmail,
      'name': name,
      'dob': dob.toIso8601String(),
      'pob': pob,
      'sex': sex,
      'nationalID': nationalID,
      'licenseNum': licenseNum,
      'phoneNum': phoneNum,
      'taxNum': taxNum,
      'address': address,
      'historical': historical,
    };
  }
}

class AdminData {
  static const username = "adrianovadmin";
  static const userType = 2;
  static const userEmail = "adrianovadmin@gmail.com";
  static const name = "Adrian";
  static final dob = DateTime(1985, 5, 15);
  static const sex = true;
  static const nationalID = "10101011010";
  static const phoneNum = "3010110101010";
  static const taxNum = "191991919";
  static const address = "ABC Street 1010";

  static Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userType': userType,
      'userEmail': userEmail,
      'name': name,
      'dob': dob.toIso8601String(),
      'sex': sex,
      'nationalID': nationalID,
      'phoneNum': phoneNum,
      'taxNum': taxNum,
      'address': address,
    };
  }
}

class StaffData {
  static const username = "adrianovstaff";
  static const userType = 3;
  static const userEmail = "adrianovstaff@gmail.com";
  static const name = "Adrian";
  static final dob = DateTime(1985, 5, 15);
  static const pob = "Bandung";
  static const sex = true;
  static const nationalID = "10101011010";
  static const licenseNum = "191991919";
  static const phoneNum = "3010110101010";
  static const taxNum = "191991919";
  static const address = "ABC Street 1010";
  static const historical = {
    "education": ["Universitas Gadjah Mada - 2024", "Universitas Gadjah Mada - 2018"],
    "experience": ["RS Sardjito - 2024"]
  };

  static Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userType': userType,
      'userEmail': userEmail,
      'name': name,
      'dob': dob.toIso8601String(),
      'pob': pob,
      'sex': sex,
      'nationalID': nationalID,
      'licenseNum': licenseNum,
      'phoneNum': phoneNum,
      'taxNum': taxNum,
      'address': address,
      'historical': historical,
    };
  }
}
