const mock_recent_contact = {
  "recent": [
    {
      "idTransaction": "ba705602-e0cd-4c13-a9ed-018cd99581ce",
      "accountNo": "010247910",
      "accountName": "NGUYEN VAN A",
      "extBankId": "970419",
      "extBankNameVn": "Ngân hàng Quốc Dân",
      "extBankNameEn": "National Citizen Bank",
      "citadBankCode": "352",
      "transactionDate": "1717578188000",
      "creditDebitIndicator": "0",
      "amount": 150000,
      "remark": "DO VAN HA chuyen tien (by TPBank ChatPay)",
      "status": "CONFIRMED",
      "sourceType": "NORMAL",
      "stranger": true,
      "debtorAccountNumber": "00000009657",
      "napasSupported": true,
      "referenceCode": "000V009191520EUx"
    },
    {
      "idTransaction": "eb2c3aa7-c03e-45ec-a9bc-eb3b501782d3",
      "accountNo": "12313123",
      "accountName": "NGUYEN VAN BANG",
      "extBankId": "970436",
      "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
      "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
      "citadBankCode": "203",
      "transactionDate": "1717578114000",
      "creditDebitIndicator": "0",
      "amount": 200000,
      "remark": "DO VAN HA chuyen tien (by TPBank ChatPay)",
      "status": "CONFIRMED",
      "sourceType": "NORMAL",
      "stranger": true,
      "debtorAccountNumber": "00000009657",
      "napasSupported": true,
      "citadCode": "01203001",
      "provinceId": "01",
      "provinceNameEn": "Ha Noi",
      "provinceNameVn": "Hà Nội",
      "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
      "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
      "referenceCode": "000CI091915205MH"
    },
    {
      "idTransaction": "417d905b-fe6c-4acb-9c93-311f2fb8cdde",
      "accountNo": "00000010841",
      "accountName": "LA THI HANG",
      "transactionDate": "1717296937000",
      "creditDebitIndicator": "0",
      "amount": 15000,
      "remark": "DO VAN HA chuyen tien (by TPBank ChatPay)",
      "status": "CONFIRMED",
      "sourceType": "PERIODIC",
      "stranger": true,
      "debtorAccountNumber": "00000009657",
      "referenceCode": "000CTMB191520BI6"
    },
    {
      "idTransaction": "840b8416-a9ab-4cda-82d5-395359c20740",
      "accountNo": "10020022401",
      "accountName": "DO VAN HA 13",
      "extBankNameVn": "Ngân hàng Thương mại Cổ phần Tiên Phong (TPBank)",
      "extBankNameEn": "Tien Phong Commercial Joint Stock Bank (TPBank)",
      "transactionDate": "1717060954000",
      "creditDebitIndicator": "0",
      "amount": 12000,
      "remark": "mua hang (by TPBank ChatPay)",
      "status": "CONFIRMED",
      "sourceType": "NORMAL",
      "stranger": true,
      "debtorAccountNumber": "00000009657",
      "referenceCode": "000CTMB191520BHr"
    }
  ],
  "strangeRecent": []
};

const mock_chat_history_response =
{
  "dataTransactions": [
    {
      "idTransaction":"1819f8f2-4520-46e3-be61-c7dd41707638",
      "accountNo":"00000177001",
      "amount":100000,
      "referenceCode":"011V0092129817OM",
      "transactionDate":"1740655695000",
      "remark":"FULLNAME00000177 chuyen tien",
      "creditDebitIndicator":"0",
      "ofsAcctNo":"010247916",
      "status":"ESB_TIMEOUT",
      "description":"ERR100",
      "extTransferType":"NAPAS",
      "sourceType":"NORMAL",
      "guarantee":"1",
      "link":"https://hydrouat.tpb.vn/retail/vX/track?id=HY230913pnsVXnLD"
    },
    {
      "idTransaction": "e7775ba8-eacf-425d-9016-4501d8aa6acc",
      "accountNo": "00060032001",
      "amount": 111132,
      "referenceCode": "201V00919154025V",
      "transactionDate": "1737977295000",
      "remark": "Luu Ha chuyen tien by chat pay Luu Ha chuyen tien by chat pay Luu Ha chuyen tien by chat pay",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "FAILED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": "",
      "postcardEmoji": {
          "postcardDetail": {
              "icon": "🤑"
          }
      }
    },
    {
      "idTransaction": "d9f31f92-3776-4665-825e-f0e3c74aac34",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025U",
      "transactionDate": "1737890895000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "",
      "postcardEmoji": {
          "postcardDetail": {
              "icon": "🤑"
          }
      }
    },
     {
      "idTransaction": "d9f31f92-3776-4665-825e-f0e3c74aa444",
      "accountNo": "00060032001",
      "amount": 4321,
      "referenceCode": "201V009191540431",
      "transactionDate": "1735212495000",
      "remark": "Chuyen tien dam bao that bai ne!",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "FAILED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230823Gb67lVrH"
    },
    {
      "idTransaction": "d9f31f92-3776-4665-825e-f0e3c74aa1s4",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V009555540431",
      "transactionDate": "1733225295000",
      "remark": "Chuyen tien dam bao that bai ne!",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "ESB_TIMEOUT",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230823Gb67lVrH",
      "description": "ERR101"
    },
    {
      "idTransaction": "e67899e4-e07c-4292-8628-ab6f91370cbe",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025T",
      "transactionDate": "1730633295000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "39ace88b-818b-4f0d-a45c-7dbc33ce04a8",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025S",
      "transactionDate": "1731497295000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822SOlt9J32"
    },
    {
      "idTransaction": "b533af27-a1b9-4e87-bdad-fcd519a4a791",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025R",
      "transactionDate": "1728818895000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822TYdYGN1x"
    },
    {
      "idTransaction": "64c18150-c434-4f63-a97f-a6a3b8460e27",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025Q",
      "transactionDate": "1729596495000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822PqldaycO"
    },
    {
      "idTransaction": "6c1c7018-c5f4-4946-9a26-7fa61a994045",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025P",
      "transactionDate": "1730028495000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822Bi5qijgq"
    },
    {
      "idTransaction": "9868a619-e657-4369-9f16-d304333ef1fb",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025O",
      "transactionDate": "1732706895000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822WYPeRTnm"
    },
    {
      "idTransaction": "47bdce81-44f8-4a5a-839f-7c850e3bf557",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025N",
      "transactionDate": "1727436495000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822v2vfKpRg"
    },
    {
      "idTransaction": "a59c372c-04e1-46f5-87eb-351b5d566985",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025M",
      "transactionDate": "1727004495000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "01020247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY2308224u7tTJFR"
    },
    {
      "idTransaction": "194cbde1-481d-4099-a73b-303c690e29f5",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025L",
      "transactionDate": "1726140495000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822M5knMoq8"
    },
    {
      "idTransaction": "4136661a-b174-47af-be98-78f3b919718a",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025K",
      "transactionDate": "1725276495000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230822AuRH1xNK"
    },
    {
      "idTransaction": "974a5ab4-4f11-410f-89bc-858e594ccd02",
      "accountNo": "00060032001",
      "amount": 100000,
      "referenceCode": "201V00919154025J",
      "transactionDate": "1735817295000",
      "remark": "chuyen tien",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": "",
      "postcardEmoji": {
          "postcardDetail": {
              "icon": "🤑"
          }
      }
    },
    {
      "idTransaction": "309852a7-7129-4882-bb69-fc670c576810",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025I",
      "transactionDate": "1737458895000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230818L3G4T9dL"
    },
    {
      "idTransaction": "c6e45981-1d11-4728-902f-6f54a696d0bb",
      "accountNo": "00060032001",
      "amount": 11111,
      "referenceCode": "201V00919154025H",
      "transactionDate": "1736594895000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230818VN7ZPAer"
    },
    {
      "idTransaction": "22d28dab-8138-44ba-9483-39944a693165",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025G",
      "transactionDate": "1692331491000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "1",
      "link": "https://hydrosit.tpb.vn/retail/vX/track?id=HY230818cUDH9lbD"
    },
    {
      "idTransaction": "d2d8a8d7-0d4e-4c44-8f66-f8d93295a2d9",
      "accountNo": "00060032001",
      "amount": 1111,
      "referenceCode": "201V00919154025F",
      "transactionDate": "1692240575000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "6313ad04-33f3-41bd-a49a-21bee7a2106c",
      "accountNo": "00060032001",
      "amount": 1234,
      "referenceCode": "201V00919154025E",
      "transactionDate": "1691655609000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "e456bff9-ec1e-4c63-9d82-fcecd83c6932",
      "accountNo": "00060032001",
      "amount": 2,
      "referenceCode": "201V00919154025D",
      "transactionDate": "1691276458000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "PERIODIC",
      "periodicId": "2c525513-151c-4ef6-968f-3853e06abad8",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "bd65fad8-cbf4-45cf-b410-52eabd9c815c",
      "accountNo": "00060032001",
      "amount": 100000,
      "referenceCode": "201V00919154025C",
      "transactionDate": "1690597057000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": "",
      "postcardEmoji": {
          "postcardDetail": {
              "icon": "🤑"
          }
      }
    },
    {
      "idTransaction": "ad11c996-76b0-47ac-a96c-236a95d75b22",
      "accountNo": "00060032001",
      "amount": 444671,
      "referenceCode": "201V00919154025B",
      "transactionDate": "1690498854000",
      "remark": "asdasdasd",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "PERIODIC",
      "periodicId": "e7374865-648c-4364-a019-a99c83393c0f",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "af97adb6-299b-4f4f-bbfd-7a96b15e4401",
      "accountNo": "00060032001",
      "amount": 444671,
      "referenceCode": "201V00919154025A",
      "transactionDate": "1689894082000",
      "remark": "asdasdasd",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "PERIODIC",
      "periodicId": "e7374865-648c-4364-a019-a99c83393c0f",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "51c8b281-b76e-4645-9a8d-ca91e9359c40",
      "accountNo": "00060032001",
      "amount": 444,
      "referenceCode": "201V009191540259",
      "transactionDate": "1689721289000",
      "remark": "asdasdasd",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "PERIODIC",
      "periodicId": "e7374865-648c-4364-a019-a99c83393c0f",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "7489af11-e9ae-4fe2-a73d-3546800be6c1",
      "accountNo": "00060032001",
      "amount": 123,
      "referenceCode": "201V0091915401xP",
      "transactionDate": "1689235718000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "a68f9c84-f700-41ab-83ed-930deaf8d910",
      "accountNo": "00060032001",
      "amount": 444,
      "referenceCode": "201V0091915401xO",
      "transactionDate": "1689116497000",
      "remark": "asdasdasd",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "PERIODIC",
      "periodicId": "e7374865-648c-4364-a019-a99c83393c0f",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "57438b41-f9e2-41ff-b66c-eb5051bb2aa0",
      "accountNo": "00060032001",
      "amount": 500000,
      "referenceCode": "201V0091915401xL",
      "transactionDate": "1688550318000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "e670358e-7395-4b50-b11b-bcafa6f90932",
      "accountNo": "00060032001",
      "amount": 2,
      "referenceCode": "201V0091915401xD",
      "transactionDate": "1687766175000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "5e067f25-6b1f-4563-aae0-ef92d0ccebac",
      "accountNo": "00060032001",
      "amount": 123,
      "referenceCode": "201V0091915401xI",
      "transactionDate": "1687423821000",
      "remark": "asdasdasd",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "356f0eea-c8c8-4fd6-835b-48492a6efeef",
      "accountNo": "00060032001",
      "amount": 44,
      "referenceCode": "ECC285392F094294",
      "transactionDate": "1702516740000",
      "remark": "asdasdasd",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "PERIODIC",
      "periodicId": "e7374865-648c-4364-a019-a99c83393c0f",
      "guarantee": "0",
      "link": "",
      "postcardEmoji": {
          "postcardDetail": {
              "icon": "🤑"
          }
      }
    },
    {
      "idTransaction": "aa8f1b5c-a7ca-4538-8a56-2823c0fc505f",
      "accountNo": "00060032001",
      "amount": 1,
      "referenceCode": "65F8745C2CDD4496",
      "transactionDate": "1686199282000",
      "remark": "mua hang",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "ESB_TIMEOUT",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "3c6be343-7d85-41e5-8aec-5e55c2949680",
      "accountNo": "00060032001",
      "amount": 145000,
      "referenceCode": "B9277B19CEB141EA",
      "transactionDate": "1686199238000",
      "remark": "chuyen tien mua hang",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "ESB_TIMEOUT",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "91a63814-5f72-46e1-90dc-0aeefb2c0752",
      "accountNo": "00060032001",
      "amount": 1,
      "referenceCode": "201V0091915401x9",
      "transactionDate": "1686024996000",
      "remark": "dsf",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "04e5b17a-b36e-4555-9cad-2b6cae77f147",
      "accountNo": "00060032001",
      "amount": 44,
      "referenceCode": "201V0091915401x7",
      "transactionDate": "1686006044000",
      "remark": "asdasdasd",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "PERIODIC",
      "periodicId": "e7374865-648c-4364-a019-a99c83393c0f",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "0d764e90-747f-4ade-ac15-9fc9439bd50b",
      "accountNo": "00060032001",
      "amount": 233,
      "referenceCode": "201V0091915401x6",
      "transactionDate": "1685520145000",
      "remark": "ahaj",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "575c6a5b-3ff8-422d-9414-4c78dfbaae4a",
      "accountNo": "00060032001",
      "amount": 100000,
      "referenceCode": "201V0091915401x5",
      "transactionDate": "1685439055000",
      "remark": "Luu Ha Anh chuyen tien chuyen tien chuyen tien",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": "",
      "postcardEmoji": {
          "postcardDetail": {
              "icon": "🤑"
          }
      }
    },
    {
      "idTransaction": "332374c0-3781-405d-8609-9c5be6591858",
      "accountNo": "00060032001",
      "amount": 100000,
      "referenceCode": "201V0091915401p1",
      "transactionDate": "1684292792000",
      "remark": "ct",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "6dcfc233-91ce-47f9-acde-b7d1a00c1f34",
      "accountNo": "00060032001",
      "amount": 11,
      "referenceCode": "201V0091915401hE",
      "transactionDate": "1682041459000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "e77d2feb-9ce3-4ab9-b18a-4279aa1acbcd",
      "accountNo": "00060032001",
      "amount": 2200000,
      "referenceCode": "201V0091915401hD",
      "transactionDate": "1730878387000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "1",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "e77d2feb-9ce3-4ab9-b18a-4279aa1acbcd",
      "accountNo": "00060032001",
      "amount": 240000,
      "referenceCode": "201V0091915401hD",
      "transactionDate": "1733470387000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "1",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "e77d2feb-9ce3-4ab9-b18a-4279aa1acbcd",
      "accountNo": "00060032001",
      "amount": 100000,
      "referenceCode": "201V0091915401hD",
      "transactionDate": "1733470387000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "1",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "e77d2feb-9ce3-4ab9-b18a-4279aa1acbcd",
      "accountNo": "00060032001",
      "amount": 50000,
      "referenceCode": "201V0091915401hD",
      "transactionDate": "1730878387000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "0",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "e77d2feb-9ce3-4ab9-b18a-4279aa1acbcd",
      "accountNo": "00060032001",
      "amount": 60000,
      "referenceCode": "201V0091915401hD",
      "transactionDate": "1738827187000",
      "remark": "Luu Ha Anh  chuyen tien (by TPBank ChatPay)",
      "creditDebitIndicator": "1",
      "ofsAcctNo": "010247910",
      "status": "CONFIRMED",
      "extTransferType": "NAPAS",
      "sourceType": "NORMAL",
      "guarantee": "0",
      "link": ""
    },
    {
      "idTransaction": "1307670a-63f4-4c28-906e-b3719ca04fbd",
      "accountNo": "99998989001",
      "amount": 8555,
      "referenceCode": "040CTMB1915501MW",
      "transactionDate": "1736594895000",
      "remark": "FULLNAME88989888 - Chung tay chien thang dai dich Covid (by TPBank ChatPay)",
      "creditDebitIndicator": "1",
      "ofsAcctNo": "88989888001",
      "postcard": {
        "sender": "88989888",
        "receiver": "99998989",
        "refCode": "040CTMB1915501MW",
        "amount": "8555",
        "postcardDetail": {
          "bgColor": "#FCF9F0",
          "content": "Chung tay chiến thắng đại dịch Covid!",
          "bottomImg": "contentservices/api/contentstream-id/contentRepository/f380b43a-09d7-4010-8350-05e67a0e2a5e?_=1623137269350",
          "type": "LUCKYMONEY"
        }
      },
      "status": "CONFIRMED",
      "sourceType": "NORMAL"
    }
  ]
};

const mock_ott_contact_list =
    {
    "contactGroupOtt": [
        {
            "cifNumber": "00025712",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 00025712",
            "ottContactInfo": [
                {
                    "id": "9d2451a5-f738-4a6f-9a90-92a4c7701672",
                    "status": "UPDATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00025712001",
                    "createdDate": "1729153266000",
                    "updatedDate": "1729584918000",
                    "lastUsedTime": "1729584918000"
                }
            ]
        },
        {
            "cifNumber": "00000128",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 00000128",
            "ottContactInfo": [
                {
                    "id": "3f7b23ce-cab6-4228-adca-981a0fe91ff3",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00000128030",
                    "createdDate": "1729151657000",
                    "lastUsedTime": "1729151657000"
                }
            ]
        },
        {
            "cifNumber": "00003806",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 00003806",
            "ottContactInfo": [
                {
                    "id": "ac977b6d-c4a3-477b-a301-3c678b8742b7",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00003806001",
                    "createdDate": "1732093372000",
                    "lastUsedTime": "1732093372000"
                }
            ]
        },
        {
            "cifNumber": "04978429",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 04978429",
            "ottContactInfo": [
                {
                    "id": "6b246314-cf01-4a6c-a8fd-fe6d02198907",
                    "status": "UPDATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "10000197043",
                    "createdDate": "1730859336000",
                    "updatedDate": "1730859919000",
                    "lastUsedTime": "1730859919000"
                }
            ]
        },
        {
            "cifNumber": "00016090",
            "favorite": false,
            "nickName": "NGUYEN NGOC ANH Nguyen ngoc an",
            "creditorName": "CUSTOMER 00016090",
            "ottContactInfo": [
                {
                    "id": "aefa5281-5f38-47b5-b58a-076d5bce0f7b",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00016090001",
                    "createdDate": "1730099948000",
                    "lastUsedTime": "1730099948000"
                }
            ]
        },
        {
            "cifNumber": "04985857",
            "favorite": false,
            "nickName": "Có nhìu STK và có 1 STK closed",
            "creditorName": "NGUYEN NGOC MAN",
            "ottContactInfo": [
                {
                    "id": "b2fdabcf-160a-4f1d-bbdd-0c7e983608f7",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00000176561",
                    "createdDate": "1715938724000"
                },
                {
                    "id": "4db9e19a-353a-42f5-b9d3-1bdf1cec23e5",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "04985857272",
                    "createdDate": "1715938900000"
                }
            ]
        },
        {
            "cifNumber": "00007669",
            "favorite": false,
            "nickName": "Man Nhi 4",
            "creditorName": "CUSTOMER 00007669",
            "ottContactInfo": [
                {
                    "id": "35c2081a-bd15-4d04-a6d8-59590a647047",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00007669002",
                    "createdDate": "1735637198000"
                }
            ]
        },
        {
            "cifNumber": "14158978",
            "favorite": false,
            "nickName": "Man Nhi 3",
            "creditorName": "NGUYEN NGOC MAN",
            "ottContactInfo": [
                {
                    "id": "e0454f18-7abc-4b48-9a0a-6635676e300b",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "10000195789",
                    "createdDate": "1735637154000"
                },
                {
                    "id": "7eb14584-45e3-4b3b-99f0-452fec1e094d",
                    "status": "UPDATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "10000005937",
                    "napasSupported": false,
                    "createdDate": "1732871574000",
                    "updatedDate": "1736220123000",
                    "lastUsedTime": "1736220123000"
                }
            ]
        },
        {
            "cifNumber": "02605756",
            "favorite": false,
            "nickName": "",
            "creditorName": "SAI THI MINH NGUYET",
            "ottContactInfo": [
                {
                    "id": "c348e943-58c9-487d-9464-e46c71071d27",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "02605756801",
                    "napasSupported": false,
                    "createdDate": "1736220975000",
                    "lastUsedTime": "1736220975000"
                }
            ]
        },
        {
            "cifNumber": "04985830",
            "favorite": false,
            "nickName": "Có 1 TK và bị closed",
            "creditorName": "NGUYEN NGOC MAN",
            "ottContactInfo": [
                {
                    "id": "0b31a8c7-da11-43b3-8e15-28252ff2eac3",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00000176429",
                    "createdDate": "1715929164000"
                }
            ]
        },
        {
            "cifNumber": "77667766",
            "favorite": false,
            "nickName": "Man Nhi 2",
            "creditorName": "CUSTOMER 77667766",
            "ottContactInfo": [
                {
                    "id": "e601f380-e5ed-4f77-8f0a-bd581a19ad43",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "77667766001",
                    "createdDate": "1732847224000"
                }
            ]
        },
        {
            "cifNumber": "15118368",
            "favorite": false,
            "nickName": "",
            "creditorName": "NGUYEN THU HUONG",
            "ottContactInfo": [
                {
                    "id": "98b6dfb80a7b4248e053a80e010a4220",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "15118368001",
                    "extBankNameVn": "Ngân hàng Thương mại Cổ Phần Tiên Phong (TPBank)",
                    "extBankNameEn": "Tien Phong Commercial Joint Stock Bank (TPBank)",
                    "napasSupported": false,
                    "paymentType": "VN_INT_TRANS_ACC",
                    "createdDate": "1575282976000",
                    "updatedDate": "1575282976000",
                    "lastUsedTime": "1575282976000"
                }
            ]
        },
        {
            "cifNumber": "01969273",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 01969273",
            "ottContactInfo": [
                {
                    "id": "5b18889e-dd3c-4e81-b3e8-bf0a1fb9de65",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "01969273801",
                    "createdDate": "1730859609000",
                    "lastUsedTime": "1730859609000"
                }
            ]
        },
        {
            "cifNumber": "04071996",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 04071996",
            "ottContactInfo": [
                {
                    "id": "5b7dfb07-84ab-4ea6-94a5-cd637cf1d98f",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "04071996101",
                    "createdDate": "1730096929000",
                    "lastUsedTime": "1730096929000"
                }
            ]
        },
        {
            "cifNumber": "08044021",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 08044021",
            "ottContactInfo": [
                {
                    "id": "f34bbb83-0434-4dda-953b-7026d7bf407c",
                    "status": "UPDATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00000167668",
                    "createdDate": "1727844993000",
                    "updatedDate": "1729497846000",
                    "lastUsedTime": "1729497846000"
                }
            ]
        },
        {
            "cifNumber": "00007124",
            "favorite": false,
            "nickName": "",
            "creditorName": "NGUYEN THU TRANG",
            "ottContactInfo": [
                {
                    "id": "98b6df9d547f4248e053a80e010a4220",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00007124001",
                    "extBankNameVn": "Ngân hàng Thương mại Cổ Phần Tiên Phong (TPBank)",
                    "extBankNameEn": "Tien Phong Commercial Joint Stock Bank (TPBank)",
                    "napasSupported": false,
                    "paymentType": "VN_INT_TRANS_ACC",
                    "createdDate": "1575282548000",
                    "updatedDate": "1575282548000",
                    "lastUsedTime": "1575282548000"
                }
            ]
        },
        {
            "cifNumber": "00026024",
            "favorite": false,
            "nickName": "",
            "creditorName": "NGUYEN THANH THUY",
            "ottContactInfo": [
                {
                    "id": "98b6dfb80a7a4248e053a80e010a4220",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00026024001",
                    "extBankNameVn": "Ngân hàng Thương mại Cổ Phần Tiên Phong (TPBank)",
                    "extBankNameEn": "Tien Phong Commercial Joint Stock Bank (TPBank)",
                    "napasSupported": false,
                    "paymentType": "VN_INT_TRANS_ACC",
                    "createdDate": "1575282976000",
                    "updatedDate": "1575282976000",
                    "lastUsedTime": "1575282976000"
                }
            ]
        },
        {
            "cifNumber": "04918531",
            "favorite": false,
            "nickName": "Man Nhi 1",
            "creditorName": "NGUYEN NGOC MAN",
            "ottContactInfo": [
                {
                    "id": "dfb0f57d-62f8-4450-8011-686de2981ea8",
                    "status": "UPDATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "04918531000",
                    "napasSupported": false,
                    "createdDate": "1714028344000",
                    "updatedDate": "1724315944000",
                    "lastUsedTime": "1724315944000"
                }
            ]
        },
        {
            "cifNumber": "00662400",
            "favorite": false,
            "nickName": "LE NGOC ANH",
            "creditorName": "CUSTOMER00662400",
            "ottContactInfo": [
                {
                    "id": "64f317b5-2e60-4e2f-a5dc-e68e840936ba",
                    "status": "UPDATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00662400316",
                    "createdDate": "1713343745000",
                    "updatedDate": "1713926897000",
                    "lastUsedTime": "1713926897000"
                },
                {
                    "id": "b8f6d0c3-74fb-45c3-bbf0-6001445a5b66",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "00662400001",
                    "createdDate": "1714013936000",
                    "lastUsedTime": "1714013936000"
                }
            ]
        },
        {
            "cifNumber": "04915060",
            "favorite": false,
            "nickName": "",
            "creditorName": "TRAN THI NGOC",
            "ottContactInfo": [
                {
                    "id": "c74c1b97-7e2e-4817-aa91-780ed9a436e3",
                    "status": "CREATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "04915060401",
                    "napasSupported": false,
                    "createdDate": "1727842734000",
                    "lastUsedTime": "1727842734000"
                }
            ]
        },
        {
            "cifNumber": "24121979",
            "favorite": false,
            "nickName": "",
            "creditorName": "CUSTOMER 24121979",
            "ottContactInfo": [
                {
                    "id": "98b6df9d547e4248e053a80e010a4220",
                    "status": "UPDATED",
                    "contactType": "INTERNAL_ACCT",
                    "accountNumber": "24121979001",
                    "extBankNameVn": "Ngân hàng Thương mại Cổ Phần Tiên Phong (TPBank)",
                    "extBankNameEn": "Tien Phong Commercial Joint Stock Bank (TPBank)",
                    "napasSupported": false,
                    "paymentType": "VN_INT_TRANS_ACC",
                    "createdDate": "1575282548000",
                    "updatedDate": "1730105086000",
                    "lastUsedTime": "1730105086000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "Pham Dinh Quoc Hung",
            "ottContactInfo": [
                {
                    "id": "98b6df7a40944248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "66243418066",
                    "citadBankCode": "646",
                    "citadCode": "01646001",
                    "extBankNameVn": "Ngân hàng Standard Chartered Bank HN",
                    "extBankNameEn": "Standard Chartered Bank HN",
                    "napasSupported": false,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng Standard Chartered Bank HN Hà Nội",
                    "branchNameEn": "Ngân hàng Standard Chartered Bank HN Hà Nội",
                    "createdDate": "1575281959000",
                    "updatedDate": "1575281959000",
                    "lastUsedTime": "1575281959000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "PHAM VAN HUNG",
            "ottContactInfo": [
                {
                    "id": "98b6df90b22e4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "108868011675",
                    "extBankId": "970415",
                    "citadBankCode": "201",
                    "citadCode": "79201001",
                    "extBankNameVn": "Ngân hàng công thương Việt Nam",
                    "extBankNameEn": "Vietnam Joint Stock Commercial Bank for Industry and Trade",
                    "napasSupported": true,
                    "provinceId": "79",
                    "provinceNameVn": "TP Hồ Chí Minh",
                    "provinceNameEn": "TP Ho Chi Minh",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng công thương Việt Nam CN TP Hồ Chí Minh",
                    "branchNameEn": "Ngân hàng công thương Việt Nam CN TP Hồ Chí Minh",
                    "createdDate": "1575282337000",
                    "updatedDate": "1575282337000",
                    "lastUsedTime": "1575282337000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN TRUONG",
            "ottContactInfo": [
                {
                    "id": "98b6df90a2f04248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "50110000481095",
                    "extBankId": "970418",
                    "citadBankCode": "202",
                    "citadCode": "38202001",
                    "extBankNameVn": "Ngân hàng Đầu tư và Phát triển Việt Nam",
                    "extBankNameEn": "Bank for Investment and Development of Vietnam",
                    "napasSupported": true,
                    "provinceId": "38",
                    "provinceNameVn": "Thanh Hóa",
                    "provinceNameEn": "Thanh Hoa",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng Đầu tư và Phát triển Việt Nam CN Thanh Hoá",
                    "branchNameEn": "Ngân hàng Đầu tư và Phát triển Việt Nam CN Thanh Hoá",
                    "createdDate": "1575282336000",
                    "updatedDate": "1575282336000",
                    "lastUsedTime": "1575282336000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "CN SGN-CTCP DL VA DV HK HOANG GIA GOTADI",
            "ottContactInfo": [
                {
                    "id": "98b6df8e1e384248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0331000428208",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "79203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "79",
                    "provinceNameVn": "TP Hồ Chí Minh",
                    "provinceNameEn": "TP Ho Chi Minh",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN TP HCM",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN TP HCM",
                    "createdDate": "1575282297000",
                    "updatedDate": "1575282297000",
                    "lastUsedTime": "1575282297000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "Luong Hoang Tung",
            "ottContactInfo": [
                {
                    "id": "98b6df9c5c3b4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0451001453800",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203003",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "003",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN Hà Nội",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN Hà Nội",
                    "createdDate": "1575282533000",
                    "updatedDate": "1575282533000",
                    "lastUsedTime": "1575282533000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN THI QUYNH DONG",
            "ottContactInfo": [
                {
                    "id": "98b6df83ea1c4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0451000415910",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575282142000",
                    "updatedDate": "1575282142000",
                    "lastUsedTime": "1575282142000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN VAN HOANG",
            "ottContactInfo": [
                {
                    "id": "98b6df8363884248e053a80e010a4220",
                    "contactType": "INTERBANK_CARD",
                    "creditorAtmCardNumber": "548566******5487",
                    "extBankId": "548566",
                    "extBankNameVn": "Ngân hàng Quân Đội",
                    "extBankNameEn": "Military Commercial Joint stock Bank",
                    "napasSupported": true,
                    "createdDate": "1575282135000",
                    "updatedDate": "1575282135000",
                    "lastUsedTime": "1575282135000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "LE HUYNH DUC",
            "ottContactInfo": [
                {
                    "id": "98b6df820fd64248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0451000274054",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575282111000",
                    "updatedDate": "1575282111000",
                    "lastUsedTime": "1575282111000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN NGOC ANH",
            "ottContactInfo": [
                {
                    "id": "98b6df83dd854248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "19032896935011",
                    "extBankId": "970407",
                    "citadBankCode": "310",
                    "citadCode": "01310001",
                    "extBankNameVn": "Ngân hàng Kỹ thương Việt Nam",
                    "extBankNameEn": "Việt Nam Technological and Commercial Joint stock Bank",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng Kỹ thương Việt Nam Hội sở chính",
                    "branchNameEn": "Ngân hàng Kỹ thương Việt Nam Hội sở chính",
                    "createdDate": "1575282141000",
                    "updatedDate": "1575282141000",
                    "lastUsedTime": "1575282141000"
                }
            ]
        },
        {
            "favorite": false,
            "nickName": "van van 1",
            "creditorName": "CTCP DAU TU & THUONG MAI SUOI GIANG",
            "ottContactInfo": [
                {
                    "id": "98b6df83ec8e4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "19131036756010",
                    "extBankId": "970407",
                    "citadBankCode": "310",
                    "citadCode": "01310001",
                    "extBankNameVn": "Ngân hàng Kỹ thương Việt Nam",
                    "extBankNameEn": "Việt Nam Technological and Commercial Joint stock Bank",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng Kỹ thương Việt Nam Hội sở chính",
                    "branchNameEn": "Ngân hàng Kỹ thương Việt Nam Hội sở chính",
                    "createdDate": "1575282142000",
                    "updatedDate": "1575282142000",
                    "lastUsedTime": "1575282142000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN VAN HOANG",
            "ottContactInfo": [
                {
                    "id": "98b6df820d074248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0491000132842",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575282111000",
                    "updatedDate": "1575282111000",
                    "lastUsedTime": "1575282111000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "VU XUAN LAI",
            "ottContactInfo": [
                {
                    "id": "98b6df7e95c74248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0351000835422",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575282042000",
                    "updatedDate": "1575282042000",
                    "lastUsedTime": "1575282042000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "LE HUYNH DUC             ",
            "ottContactInfo": [
                {
                    "id": "98b6df7f6f984248e053a80e010a4220",
                    "contactType": "INTERBANK_CARD",
                    "creditorAtmCardNumber": "970436*********1014",
                    "extBankId": "686868",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "createdDate": "1575282060000",
                    "updatedDate": "1575282060000",
                    "lastUsedTime": "1575282060000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN VAN HOANG         ",
            "ottContactInfo": [
                {
                    "id": "98b6df802d624248e053a80e010a4220",
                    "contactType": "INTERBANK_CARD",
                    "creditorAtmCardNumber": "970436*********8012",
                    "extBankId": "686868",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "createdDate": "1575282073000",
                    "updatedDate": "1575282073000",
                    "lastUsedTime": "1575282073000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "CTY CP CO KHI XAY DUNG DAI MO",
            "ottContactInfo": [
                {
                    "id": "98b6dfb4586c4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "01600000336699",
                    "extBankId": "970440",
                    "citadBankCode": "317",
                    "citadCode": "01317001",
                    "extBankNameVn": "Ngân hàng TMCP Đông Nam Á",
                    "extBankNameEn": "South East Asia Commercial Joint stock  Bank",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Đông Nam Á HSC - Ha Noi",
                    "branchNameEn": "Ngân hàng TMCP Đông Nam Á HSC - Ha Noi",
                    "createdDate": "1575282917000",
                    "updatedDate": "1575282917000",
                    "lastUsedTime": "1575282917000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "LUONG HOAN PHUNG",
            "ottContactInfo": [
                {
                    "id": "98b6dfafb1c74248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "106006311669",
                    "extBankId": "970415",
                    "citadBankCode": "201",
                    "citadCode": "84201001",
                    "extBankNameVn": "Ngân hàng công thương Việt Nam",
                    "extBankNameEn": "Vietnam Joint Stock Commercial Bank for Industry and Trade",
                    "napasSupported": true,
                    "provinceId": "84",
                    "provinceNameVn": "Trà Vinh",
                    "provinceNameEn": "Tra Vinh",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng công thương Việt Nam CN Trà Vinh",
                    "branchNameEn": "Ngân hàng công thương Việt Nam CN Trà Vinh",
                    "createdDate": "1575282844000",
                    "updatedDate": "1575282844000",
                    "lastUsedTime": "1575282844000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "LE THI THAO",
            "ottContactInfo": [
                {
                    "id": "98b6dfa2e7ef4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "12010006679606",
                    "extBankId": "970418",
                    "citadBankCode": "202",
                    "citadCode": "01202001",
                    "extBankNameVn": "Ngân hàng Đầu tư và Phát triển Việt Nam",
                    "extBankNameEn": "Bank for Investment and Development of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng Đầu tư và Phát triển Việt Nam Viet Nam",
                    "branchNameEn": "Ngân hàng Đầu tư và Phát triển Việt Nam Viet Nam",
                    "createdDate": "1575282636000",
                    "updatedDate": "1575282636000",
                    "lastUsedTime": "1575282636000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "Vu Minh Luong",
            "ottContactInfo": [
                {
                    "id": "98b6df70f9314248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0011001901681",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203008",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "008",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN Hoàn Kiếm",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN Hoàn Kiếm",
                    "createdDate": "1575281813000",
                    "updatedDate": "1575281813000",
                    "lastUsedTime": "1575281813000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "Tran Quang Hai",
            "ottContactInfo": [
                {
                    "id": "98b6df702cce4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0560100090908",
                    "extBankId": "970422",
                    "citadBankCode": "311",
                    "citadCode": "01311009",
                    "extBankNameVn": "Ngân hàng Quân Đội",
                    "extBankNameEn": "Military Commercial Joint stock Bank",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "009",
                    "branchNameVn": "Ngân hàng Quân Đội CN Hoàng Quốc Việt",
                    "branchNameEn": "Ngân hàng Quân Đội CN Hoàng Quốc Việt",
                    "createdDate": "1575281799000",
                    "updatedDate": "1575281799000",
                    "lastUsedTime": "1575281799000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "PHAM BICH CHUNG",
            "ottContactInfo": [
                {
                    "id": "98b6df70bec34248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0451000225259",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203006",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "006",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN Thành Công",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN Thành Công",
                    "createdDate": "1575281810000",
                    "updatedDate": "1575281810000",
                    "lastUsedTime": "1575281810000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "VUONG QUANG VU",
            "ottContactInfo": [
                {
                    "id": "98b6df716c014248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0021001840618",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203003",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "003",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN Hà Nội",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN Hà Nội",
                    "createdDate": "1575281820000",
                    "updatedDate": "1575281820000",
                    "lastUsedTime": "1575281820000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "VU MINH LUONG",
            "ottContactInfo": [
                {
                    "id": "98b6df711df94248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0011001901681",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203008",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "008",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN Hoàn Kiếm",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN Hoàn Kiếm",
                    "createdDate": "1575281816000",
                    "updatedDate": "1575281816000",
                    "lastUsedTime": "1575281816000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "LE DUC HAU",
            "ottContactInfo": [
                {
                    "id": "98b6df720c574248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0021001263139",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203004",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "004",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN Thăng Long",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN Thăng Long",
                    "createdDate": "1575281831000",
                    "updatedDate": "1575281831000",
                    "lastUsedTime": "1575281831000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "VU MINH LUONG",
            "ottContactInfo": [
                {
                    "id": "98b6df8c1d1c4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "13820368230010",
                    "extBankId": "970407",
                    "citadBankCode": "310",
                    "citadCode": "01310001",
                    "extBankNameVn": "Ngân hàng Kỹ thương Việt Nam",
                    "extBankNameEn": "Việt Nam Technological and Commercial Joint stock Bank",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng Kỹ thương Việt Nam Hội sở chính",
                    "branchNameEn": "Ngân hàng Kỹ thương Việt Nam Hội sở chính",
                    "createdDate": "1575282266000",
                    "updatedDate": "1575282266000",
                    "lastUsedTime": "1575282266000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "TRAN QUANG HAI",
            "ottContactInfo": [
                {
                    "id": "98b6dfa0a2604248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0491001511733",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575282598000",
                    "updatedDate": "1575282598000",
                    "lastUsedTime": "1575282598000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "PHAN NGOC HUAN",
            "ottContactInfo": [
                {
                    "id": "98b6dfa5ff984248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0451000274016",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575282691000",
                    "updatedDate": "1575282691000",
                    "lastUsedTime": "1575282691000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "Pham Dinh Quoc Hung",
            "ottContactInfo": [
                {
                    "id": "98b6dfa4dde74248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "19027074946999",
                    "extBankId": "970407",
                    "citadBankCode": "310",
                    "citadCode": "01310012",
                    "extBankNameVn": "Ngân hàng Kỹ thương Việt Nam",
                    "extBankNameEn": "Việt Nam Technological and Commercial Joint stock Bank",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "012",
                    "branchNameVn": "Ngân hàng Kỹ thương Việt Nam CN Hà Thành",
                    "branchNameEn": "Ngân hàng Kỹ thương Việt Nam CN Hà Thành",
                    "createdDate": "1575282671000",
                    "updatedDate": "1575282671000",
                    "lastUsedTime": "1575282671000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN CHI HUU",
            "ottContactInfo": [
                {
                    "id": "98b6dfbb7b014248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0691000317965",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575283029000",
                    "updatedDate": "1575283029000",
                    "lastUsedTime": "1575283029000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "LE THI BICH",
            "ottContactInfo": [
                {
                    "id": "98b6dfbb98574248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0781000428625",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "38203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "38",
                    "provinceNameVn": "Thanh Hóa",
                    "provinceNameEn": "Thanh Hoa",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương CN Thanh Hóa",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương CN Thanh Hóa",
                    "createdDate": "1575283030000",
                    "updatedDate": "1575283030000",
                    "lastUsedTime": "1575283030000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "VU THANH XUAN",
            "ottContactInfo": [
                {
                    "id": "98b6dfb2277a4248e053a80e010a4220",
                    "contactType": "INTERBANK_CARD",
                    "creditorAtmCardNumber": "970436*********9016",
                    "extBankId": "686868",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "createdDate": "1575282883000",
                    "updatedDate": "1575282883000",
                    "lastUsedTime": "1575282883000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "PHAN THANH TUNG",
            "ottContactInfo": [
                {
                    "id": "98b6dfaf7b424248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0021000308734",
                    "extBankId": "970436",
                    "citadBankCode": "203",
                    "citadCode": "01203001",
                    "extBankNameVn": "Ngân hàng TMCP Ngoại Thương",
                    "extBankNameEn": "Joint Stock Commercial Bank for Foreign Trade of Vietnam",
                    "napasSupported": true,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "branchNameEn": "Ngân hàng TMCP Ngoại Thương Viet Nam",
                    "createdDate": "1575282841000",
                    "updatedDate": "1575282841000",
                    "lastUsedTime": "1575282841000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "B",
            "ottContactInfo": [
                {
                    "id": "98b6dfac8a3b4248e053a80e010a4220",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "12010006685427",
                    "extBankId": "970418",
                    "citadBankCode": "202",
                    "citadCode": "79202001",
                    "extBankNameVn": "Ngân hàng Đầu tư và Phát triển Việt Nam",
                    "extBankNameEn": "Bank for Investment and Development of Vietnam",
                    "napasSupported": false,
                    "provinceId": "79",
                    "provinceNameVn": "TP Hồ Chí Minh",
                    "provinceNameEn": "TP Ho Chi Minh",
                    "branchId": "001",
                    "branchNameVn": "Ngân hàng Đầu tư và Phát triển Việt Nam Viet Nam",
                    "branchNameEn": "Ngân hàng Đầu tư và Phát triển Việt Nam Viet Nam",
                    "createdDate": "1575282797000",
                    "updatedDate": "1729220370000",
                    "lastUsedTime": "1729220370000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "TRAN QUOC VIET",
            "ottContactInfo": [
                {
                    "id": "996d6de3-93f1-4add-807a-5e64ab98db4d",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "017154567",
                    "extBankId": "970457",
                    "citadBankCode": "624",
                    "extBankNameVn": "Ngân hàng Woori Việt Nam",
                    "extBankNameEn": "Woori Bank Viet Nam",
                    "napasSupported": true,
                    "createdDate": "1714722062000",
                    "lastUsedTime": "1714722062000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "TRAN VAN NAM",
            "ottContactInfo": [
                {
                    "id": "408b8063-d212-4e2b-a03a-2f791754ee7e",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "017154568",
                    "extBankId": "970457",
                    "citadBankCode": "624",
                    "extBankNameVn": "Ngân hàng Woori Việt Nam",
                    "extBankNameEn": "Woori Bank Viet Nam",
                    "napasSupported": true,
                    "createdDate": "1714722272000",
                    "lastUsedTime": "1714722272000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "NGUYEN VAN A",
            "ottContactInfo": [
                {
                    "id": "d8c0e033-1cac-4b4d-bcbe-03e6aef069ae",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "010247910",
                    "extBankId": "963368",
                    "extBankNameVn": "Công ty Tài chính TNHH MTV Shinhan Việt Nam",
                    "extBankNameEn": "Shinhan Finance",
                    "napasSupported": true,
                    "createdDate": "1732763573000"
                }
            ]
        },
        {
            "favorite": false,
            "nickName": "Van van",
            "creditorName": "DO VAN PHONG",
            "ottContactInfo": [
                {
                    "id": "1bfa88a6-a62e-4796-bae4-18fbf33c7309",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0147977110",
                    "extBankId": "971100",
                    "extBankNameVn": "NAPAS",
                    "extBankNameEn": "NAPAS",
                    "napasSupported": true,
                    "createdDate": "1715827470000",
                    "updatedDate": "1716285453000",
                    "lastUsedTime": "1716285453000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "VU DUY CHINH",
            "ottContactInfo": [
                {
                    "id": "61edd0fb-de08-4a7f-b29f-e4527c7b6501",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0972889744",
                    "extBankId": "970407",
                    "citadBankCode": "310",
                    "extBankNameVn": "Ngân hàng Kỹ thương Việt Nam",
                    "extBankNameEn": "Vietnam Technological and Commercial Joint stock Bank",
                    "napasSupported": true,
                    "createdDate": "1715824021000",
                    "lastUsedTime": "1715824021000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "VP",
            "ottContactInfo": [
                {
                    "id": "19626b5a-f842-4d46-a82b-da9c2b1aeffc",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0972889744",
                    "extBankId": "981957",
                    "citadBankCode": "309",
                    "citadCode": "01309001",
                    "extBankNameVn": "Ngân hàng Thương mại cổ phần Việt Nam Thịnh Vượng",
                    "extBankNameEn": "VietNam prosperity Joint stock commercial Bank",
                    "napasSupported": false,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "createdDate": "1715824071000",
                    "lastUsedTime": "1715824071000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "DO VAN PHONG",
            "ottContactInfo": [
                {
                    "id": "4a1c4c8c-c642-43cd-a6ed-95b96272e424",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0972889744",
                    "extBankId": "970454",
                    "citadBankCode": "327",
                    "extBankNameVn": "NHTMCP Bản Việt",
                    "extBankNameEn": "BanViet Commercial Jont stock Bank",
                    "napasSupported": true,
                    "createdDate": "1715823204000",
                    "lastUsedTime": "1715823204000"
                }
            ]
        },
        {
            "favorite": false,
            "nickName": "NGUYEN QUOC HKHHKHJHANH",
            "creditorName": "NGUYEN QUOC KHANH",
            "ottContactInfo": [
                {
                    "id": "5e53966b-d804-449b-aa08-85fe7645cc2f",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "0972889744",
                    "extBankId": "970415",
                    "citadBankCode": "201",
                    "extBankNameVn": "Ngân hàng Công Thương Việt Nam",
                    "extBankNameEn": "Vietnam Joint Stock Commercial Bank for Industry and Trade",
                    "napasSupported": true,
                    "createdDate": "1715823259000",
                    "updatedDate": "1727852039000",
                    "lastUsedTime": "1727852039000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "mn",
            "ottContactInfo": [
                {
                    "id": "345b217a-3679-43cb-9647-004cca364381",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "3468998643",
                    "extBankId": "970454",
                    "citadBankCode": "327",
                    "citadCode": "01327001",
                    "extBankNameVn": "NHTMCP Bản Việt",
                    "extBankNameEn": "BanViet Commercial Jont stock Bank",
                    "napasSupported": false,
                    "provinceId": "01",
                    "provinceNameVn": "Hà Nội",
                    "provinceNameEn": "Ha Noi",
                    "createdDate": "1708399399000",
                    "lastUsedTime": "1708399399000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "Timo",
            "ottContactInfo": [
                {
                    "id": "20b45967-3728-44fd-a782-fed00ffe5742",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "3457998643",
                    "extBankId": "963388",
                    "citadBankCode": "327",
                    "citadCode": "79327001",
                    "extBankNameVn": "NHTMCP Bản Việt Timo",
                    "extBankNameEn": "Timo by Ban Viet Bank",
                    "napasSupported": false,
                    "provinceId": "79",
                    "provinceNameVn": "TP Hồ Chí Minh",
                    "provinceNameEn": "TP Ho Chi Minh",
                    "createdDate": "1708399497000",
                    "lastUsedTime": "1708399497000"
                }
            ]
        },
        {
            "favorite": false,
            "creditorName": "PG",
            "ottContactInfo": [
                {
                    "id": "b1c1f19b-ea90-451a-a655-33e82de1b7fa",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "67959276584",
                    "extBankId": "970430",
                    "citadBankCode": "341",
                    "citadCode": "79341001",
                    "extBankNameVn": "Ngân hàng TMCP Thịnh vượng và Phát triển",
                    "extBankNameEn": "Prosperity and Growth Commercial Joint Stock Bank",
                    "napasSupported": false,
                    "provinceId": "79",
                    "provinceNameVn": "TP Hồ Chí Minh",
                    "provinceNameEn": "TP Ho Chi Minh",
                    "createdDate": "1708399591000",
                    "lastUsedTime": "1708399591000"
                }
            ]
        },
        {
            "favorite": false,
            "nickName": "NGUYEN VAN SAU",
            "creditorName": "NGUYEN VAN A",
            "ottContactInfo": [
                {
                    "id": "5764e66d-ca07-4cc5-9c6d-cac154595bc4",
                    "contactType": "INTERBANK_ACCT",
                    "accountNumber": "010247910",
                    "extBankId": "970419",
                    "citadBankCode": "352",
                    "extBankNameVn": "NGÂN HÀNG QUỐC DÂN",
                    "extBankNameEn": "NATIONAL CITIZEN BANK",
                    "napasSupported": true,
                    "createdDate": "1715741797000",
                    "updatedDate": "1732525910000",
                    "lastUsedTime": "1732525910000"
                }
            ]
        }
    ]
};