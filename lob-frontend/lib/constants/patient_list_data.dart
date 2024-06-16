import 'package:flutter/material.dart';

Map<String, dynamic> patientListData = {
  "patients": [
    {
      "patient_id": "P001",
      "username": "adrianovpatient",
      "user_email": "adrianovpatient@gmail.com",
      "name": "Adrian Naufal Riadi",
      "dob": DateTime(1985, 5, 15).millisecondsSinceEpoch ~/ 1000,
      "national_id": "10101011010",
      "phone_num": "3010110101010",
      "address": "ABC Street 1010",
      "alias": "Adrian",
      "relative_phone": "1010101010",
      "insurance": {
        "insurance_id": "91010101001-10110-101010",
        "insurance_name": "BPJS"
      },
      "sex": true,
      "medical_record": [
        {
          "clinical_entry": [
            {
              "entry_date": DateTime(2024, 5, 15).millisecondsSinceEpoch ~/ 1000,
              "height": 184,
              "weight": 81,
              "body_temp": 27,
              "blood_type": "AB",
              "systolic": 144,
              "diastolic": 112,
              "note": "tidak waras"
            },
            {
              "date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
              "height": 184,
              "weight": 81,
              "body_temp": 27,
              "blood_type": "AB",
              "systolic": 144,
              "diastolic": 112,
              "note": "tidak waras"
            }
          ],
          "medical_note": [
            {
              "entry_date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001000.pdf",
              "diagnosis": "Cancer Stage 4"
            },
            {
              "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001011.pdf",
              "diagnosis": "Cancer Stage 4"
            }
          ]
        }
      ]
    },
    {
      "patient_id": "P002",
      "username": "janedoe",
      "user_email": "janedoe@gmail.com",
      "name": "Jane Doe",
      "dob": DateTime(1992, 4, 10).millisecondsSinceEpoch ~/ 1000,
      "national_id": "20202022020",
      "phone_num": "4020220202020",
      "address": "XYZ Avenue 2020",
      "alias": "Jane",
      "relative_phone": "2020202020",
      "insurance": {
        "insurance_id": "92020202002-20220-202020",
        "insurance_name": "ABC Health"
      },
      "sex": false,
      "medical_record": [
        {
          "clinical_entry": [
            {
              "entry_date": DateTime(2024, 2, 20).millisecondsSinceEpoch ~/ 1000,
              "height": 170,
              "weight": 65,
              "body_temp": 36.5,
              "blood_type": "O",
              "systolic": 120,
              "diastolic": 80,
              "note": "Healthy"
            }
          ],
          "medical_note": [
            {
              "entry_date": DateTime(2024, 1, 2).millisecondsSinceEpoch ~/ 1000,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001000.pdf",
              "diagnosis": "Cancer Stage 4"
            },
            {
              "date": DateTime(2024, 3, 2).millisecondsSinceEpoch ~/ 1000,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001011.pdf",
              "diagnosis": "Cancer Stage 4"
            }
          ]
        }
      ]
    },
    {
      "patient_id": "P008",
      "username": "johnsmith",
      "user_email": "johnsmith@gmail.com",
      "name": "John Smith",
      "dob": 810998400,
      "national_id": "80808080808",
      "phone_num": "8080808080808",
      "address": "LMN Street 8080",
      "alias": "John",
      "relative_phone": "8080808080",
      "insurance": {
        "insurance_id": "98080808008-80880-808080",
        "insurance_name": "QRS Health"
      },
      "sex": true,
      "medical_record": [
        {
          "clinical_entry": [
            {
              "entry_date": 1807449600,
              "height": 175,
              "weight": 75,
              "body_temp": 36.9,
              "blood_type": "A",
              "systolic": 125,
              "diastolic": 80,
              "note": "Good health"
            }
          ],
          "medical_note": [
            {
              "entry_date": 1807449600,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001000.pdf",
              "diagnosis": "Cancer Stage 4"
            },
            {
              "date": 1807449600,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001011.pdf",
              "diagnosis": "Cancer Stage 4"
            }
          ]
        }
      ]
    },
    {
      "patient_id": "P009",
      "username": "emilybrown",
      "user_email": "emilybrown@gmail.com",
      "name": "Emily Brown",
      "dob": 891792000,
      "national_id": "90909090909",
      "phone_num": "9090909090909",
      "address": "OPQ Boulevard 9090",
      "alias": "Emily",
      "relative_phone": "9090909090",
      "insurance": {
        "insurance_id": "99090909009-90990-909090",
        "insurance_name": "TUV Health"
      },
      "sex": false,
      "medical_record": [
        {
          "clinical_entry": [
            {
              "entry_date": 1867747200,
              "height": 160,
              "weight": 55,
              "body_temp": 37.2,
              "blood_type": "B",
              "systolic": 110,
              "diastolic": 70,
              "note": "Healthy"
            }
          ],
          "medical_note": [
            {
              "entry_date": 1867747200,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001000.pdf",
              "diagnosis": "Cancer Stage 4"
            },
            {
              "date": 1867747200,
              "note_content": "Lorem Ipsum dolor sit Amet",
              "attachment": "http://localhost:9000/file/id-101001011.pdf",
              "diagnosis": "Cancer Stage 4"
            }
          ]
        }
      ]
    },
    {
      "patient_id": "P010",
      "username": "williamjones",
      "user_email": "williamjones@gmail.com",
      "name": "William Jones",
      "dob": 943334400,
      "national_id": "101010101010",
      "phone_num": "10101010101010",
      "address": "STU Lane 1010",
      "alias": "Will",
      "relative_phone": "101010101010",
      "insurance": {
        "insurance_id": "101010101010-10100-101010",
        "insurance_name": "VWX Health"
      },
      "sex": true,
      "medical_record": [
        {
          "clinical_entry": [],
          "medical_note": []
        }
      ]
    }
  ]
};
