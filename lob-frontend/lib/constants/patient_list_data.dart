import 'package:flutter/material.dart';

Map<String, dynamic> patientListData = {
  "patients": [
    {
      "patientID": "P001",
      "username": "adrianovpatient",
      "userEmail": "adrianovpatient@gmail.com",
      "name": "Adrian Naufal Riadi",
      "dob": DateTime(1985, 5, 15).millisecondsSinceEpoch ~/ 1000,
      "nationalID": "10101011010",
      "phoneNum": "3010110101010",
      "address": "ABC Street 1010",
      "alias": "Adrian",
      "relativePhone": "1010101010",
      "insurance": {
        "insurance_id": "91010101001-10110-101010",
        "insurance_name": "BPJS"
      },
      "sex": true,
      "medicalRecord": {
        "clinicalEntry": [
          {
            "date": DateTime(2024, 5, 15).millisecondsSinceEpoch ~/ 1000,
            "height": 184,
            "weight": 81,
            "bodyTemp": 27,
            "bloodType": "AB",
            "systolic": 144,
            "diastolic": 112,
            "note": "tidak waras"
          },
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "height": 184,
            "weight": 81,
            "bodyTemp": 27,
            "bloodType": "AB",
            "systolic": 144,
            "diastolic": 112,
            "note": "tidak waras"
          },
        ],
        "medicalNote": [
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001000.pdf",
            "diagnosis": "Cancer Stage 4"
          },
          {
            "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001011.pdf",
            "diagnosis": "Cancer Stage 4"
          }
        ]
      }
    },
    {
      "patientID": "P002",
      "username": "janedoe",
      "userEmail": "janedoe@gmail.com",
      "name": "Jane Doe",
      "dob": DateTime(1992, 4, 10).millisecondsSinceEpoch ~/ 1000,
      "nationalID": "20202022020",
      "phoneNum": "4020220202020",
      "address": "XYZ Avenue 2020",
      "alias": "Jane",
      "relativePhone": "2020202020",
      "insurance": {
        "insurance_id": "92020202002-20220-202020",
        "insurance_name": "ABC Health"
      },
      "sex": false,
      "medicalRecord": {
        "clinicalEntry": [
          {
            "date": DateTime(2024, 2, 20).millisecondsSinceEpoch ~/ 1000,
            "height": 170,
            "weight": 65,
            "bodyTemp": 36.5,
            "bloodType": "O",
            "systolic": 120,
            "diastolic": 80,
            "note": "Healthy"
          }
        ],
        "medicalNote": [
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001000.pdf",
            "diagnosis": "Cancer Stage 4"
          },
          {
            "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001011.pdf",
            "diagnosis": "Cancer Stage 4"
          }
        ]
      }
    },
    {
      "patientID": "P003",
      "username": "robertlee",
      "userEmail": "robertlee@gmail.com",
      "name": "Robert Lee",
      "dob": DateTime(1975, 6, 18).millisecondsSinceEpoch ~/ 1000,
      "nationalID": "30303033030",
      "phoneNum": "5030330303030",
      "address": "MNO Way 3030",
      "alias": "Rob",
      "relativePhone": "3030303030",
      "insurance": {
        "insurance_id": "93030303003-30330-303030",
        "insurance_name": "DEF Health"
      },
      "sex": true,
      "medicalRecord": {
        "clinicalEntry": [
          {
            "date": DateTime(2024, 3, 5).millisecondsSinceEpoch ~/ 1000,
            "height": 175,
            "weight": 80,
            "bodyTemp": 37,
            "bloodType": "A",
            "systolic": 130,
            "diastolic": 85,
            "note": "Mild hypertension"
          }
        ],
        "medicalNote": [
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001000.pdf",
            "diagnosis": "Cancer Stage 4"
          },
          {
            "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001011.pdf",
            "diagnosis": "Cancer Stage 4"
          }
        ]
      }
    },
    {
      "patientID": "P004",
      "username": "lucybrown",
      "userEmail": "lucybrown@gmail.com",
      "name": "Lucy Brown",
      "dob": DateTime(2000, 2, 25).millisecondsSinceEpoch ~/ 1000,
      "nationalID": "40404044040",
      "phoneNum": "6040440404040",
      "address": "PQR Street 4040",
      "alias": "Lucy",
      "relativePhone": "4040404040",
      "insurance": {
        "insurance_id": "94040404004-40440-404040",
        "insurance_name": "GHI Health"
      },
      "sex": false,
      "medicalRecord": {
        "clinicalEntry": [
          {
            "date": DateTime(2024, 4, 10).millisecondsSinceEpoch ~/ 1000,
            "height": 165,
            "weight": 55,
            "bodyTemp": 36.8,
            "bloodType": "B",
            "systolic": 110,
            "diastolic": 70,
            "note": "Healthy"
          }
        ],
        "medicalNote": [
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001000.pdf",
            "diagnosis": "Cancer Stage 4"
          },
          {
            "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001011.pdf",
            "diagnosis": "Cancer Stage 4"
          }
        ]
      }
    },
    {
      "patientID": "P005",
      "username": "michaeljohnson",
      "userEmail": "michaeljohnson@gmail.com",
      "name": "Michael Johnson",
      "dob": DateTime(1980, 11, 5).millisecondsSinceEpoch ~/ 1000,
      "nationalID": "50505055050",
      "phoneNum": "7050550505050",
      "address": "JKL Lane 5050",
      "alias": "Mike",
      "relativePhone": "5050505050",
      "insurance": {
        "insurance_id": "95050505005-50550-505050",
        "insurance_name": "JKL Health"
      },
      "sex": true,
      "medicalRecord": {
        "clinicalEntry": [
          {
            "date": DateTime(2024, 6, 1).millisecondsSinceEpoch ~/ 1000,
            "height": 180,
            "weight": 85,
            "bodyTemp": 37.2,
            "bloodType": "A",
            "systolic": 125,
            "diastolic": 82,
            "note": "Good health"
          }
        ],
        "medicalNote": [
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001000.pdf",
            "diagnosis": "Cancer Stage 4"
          },
          {
            "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001011.pdf",
            "diagnosis": "Cancer Stage 4"
          }
        ]
      }
    },
    {
      "patientID": "P006",
      "username": "alicewong",
      "userEmail": "alicewong@gmail.com",
      "name": "Alice Wong",
      "dob": DateTime(1983, 1, 30).millisecondsSinceEpoch ~/ 1000,
      "nationalID": "60606066060",
      "phoneNum": "8060660606060",
      "address": "GHI Boulevard 6060",
      "alias": "Alice",
      "relativePhone": "6060606060",
      "insurance": {
        "insurance_id": "96060606006-60660-606060",
        "insurance_name": "LMN Health"
      },
      "sex": false,
      "medicalRecord": {
        "clinicalEntry": [
          {
            "date": DateTime(2024, 7, 15).millisecondsSinceEpoch ~/ 1000,
            "height": 168,
            "weight": 58,
            "bodyTemp": 36.9,
            "bloodType": "O",
            "systolic": 115,
            "diastolic": 75,
            "note": "No issues"
          }
        ],
        "medicalNote": [
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001000.pdf",
            "diagnosis": "Cancer Stage 4"
          },
          {
            "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001011.pdf",
            "diagnosis": "Cancer Stage 4"
          }
        ]
      }
    },
    {
      "patientID": "P007",
      "username": "danielsmith",
      "userEmail": "danielsmith@gmail.com",
      "name": "Daniel Smith",
      "dob": DateTime(1972, 9, 12).millisecondsSinceEpoch ~/ 1000,
      "nationalID": "70707077070",
      "phoneNum": "9070770707070",
      "address": "STU Street 7070",
      "alias": "Dan",
      "relativePhone": "7070707070",
      "insurance": {
        "insurance_id": "97070707007-70770-707070",
        "insurance_name": "OPQ Health"
      },
      "sex": true,
      "medicalRecord": {
        "clinicalEntry": [
          {
            "date": DateTime(2024, 8, 20).millisecondsSinceEpoch ~/ 1000,
            "height": 178,
            "weight": 90,
            "bodyTemp": 37,
            "bloodType": "B",
            "systolic": 135,
            "diastolic": 88,
            "note": "Mild obesity"
          }
        ],
        "medicalNote": [
          {
            "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001000.pdf",
            "diagnosis": "Cancer Stage 4"
          },
          {
            "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
            "noteContent": "Lorem Ipsum dolor sit Amet",
            "attachment": "http://localhost:9000/file/id-101001011.pdf",
            "diagnosis": "Cancer Stage 4"
          }
        ]
      }
    },
  ]
};