import 'package:flutter/material.dart';

class OptionModel{
  OptionModel({
    required this.label, required this.inputs, this.options = const [], this.isTransaction = false, this.isService = false
  }){
    if(options.isNotEmpty){
      for (var option in options) {
        option.inputs = [...inputs, ...option.inputs];
      }
    }
  }

  OptionModel.fromMap(Map map){
    label = map['label'].toString();
    isTransaction = map['isTransaction'] == true;
    isService = map['isService'] == true;
    options = List<Map>.from(map['options']).map((e) => OptionModel.fromMap(e)).toList();
    inputs = List<Map>.from(map['inputs']).map((e) => OptionInput.fromMap(e)).toList();
  }
  OptionModel.fromAnother(OptionModel other, {required this.label, required List<OptionModel> options, required List<OptionInput> inputs, this.isTransaction = false, this.isService = false}){
    isTransaction = isTransaction || other.isTransaction;
    isService = isService || other.isService;
    this.options = [...other.options, ...options];
    this.inputs = [...other.inputs, ...inputs];
  }

  late String label;
  late List<OptionModel> options;
  late List<OptionInput> inputs;
  late bool isTransaction;
  late bool isService;

  String get key => label.replaceAllMapped(' ', (match) => '').toLowerCase();

  Map<String, dynamic> asMap()=>{
    'label': label,
    'isTransaction': isTransaction,
    'isService': isService,
    'options': options.map((e) => e.asMap()).toList(),
    'inputs': inputs.map((e) => e.asMap()).toList(),
  };
}

class OptionInput{
  OptionInput({
    required this.label, required this.type, this.key, this.value, this.minLength = 0, this.maxLength = 0
  });
  OptionInput.amount({this.label = 'Enter Amount', this.type= OptionInputType.number, this.minLength = 1, this.maxLength = 10});
  OptionInput.pin({this.label = 'Enter M-PESA PIN', this.type= OptionInputType.pin, this.minLength = 4, this.maxLength = 4});
  OptionInput.phoneNumber({this.key = 'PhoneNo', this.label = 'Enter Phone Number', this.type= OptionInputType.phone, this.minLength = 10, this.maxLength = 13});

  OptionInput.fromMap(Map map){
    key = map['key']?.toString();
    label = map['label'].toString();
    value = map['value']?.toString();

    try {
      type = OptionInputType.values.byName(map['type'].toString());
    } catch (e) {
      type = OptionInputType.value;
    }
  }

  String? key;
  late String label;
  late OptionInputType type;
  String? value;
  int minLength = 0;
  int maxLength = 0;

  Map<String, dynamic> asMap()=>{
    'label': label,
    'type': type.name,
    'value': value,
    'minLength': minLength,
    'maxLength': maxLength
  };
}

enum OptionInputType{
  fixed, phone, number, pin, value, numberValue
}

extension OptionInputTypeExt on OptionInputType{
  TextInputType? get textInputType{
    switch (this) {
      case OptionInputType.phone:
        return TextInputType.phone;
      case OptionInputType.number:
      case OptionInputType.numberValue:
      case OptionInputType.pin:
        return TextInputType.number;
      default:
      return null;
    }
  }
}

List<OptionModel> friquents = [
  // send
  OptionModel(
    label: 'Send', 
    isTransaction: true,
    inputs: [
      OptionInput(label: 'Send Money', type: OptionInputType.fixed, value: '1'),
      OptionInput(label: 'Send Money', type: OptionInputType.fixed, value: '1'),
      OptionInput.phoneNumber(),
      OptionInput.amount(),
      OptionInput.pin(),
    ]
  ),

  // Withdraw
  OptionModel(
    label: 'Withdraw', 
    isTransaction: true,
    inputs: [
      OptionInput(label: 'Withdraw Cash', type: OptionInputType.fixed, value: '2'),
      OptionInput(label: 'From Agent', type: OptionInputType.fixed, value: '1'),
      OptionInput(key: 'AgentNo', label: 'Enter Agent Number', type: OptionInputType.numberValue, minLength: 4, maxLength: 8),
      OptionInput.amount(),
      OptionInput.pin(),
    ]
  ),

  // Paybill
  OptionModel(
    label: 'Pay Bill', 
    isTransaction: true,
    inputs: [
      OptionInput(label: 'Lipa na M-PESA', type: OptionInputType.fixed, value: '6'),
      OptionInput(label: 'Pay Bill', type: OptionInputType.fixed, value: '1'),
      OptionInput(key: 'BusinessNo', label: 'Enter Business Number', type: OptionInputType.numberValue, minLength: 0, maxLength: 20),
      OptionInput(key: 'AccountNo', label: 'Enter Account Number', type: OptionInputType.value, minLength: 0, maxLength: 20),
      OptionInput.amount(),
      OptionInput.pin(),
    ]
  ),

  // Buy goods
  OptionModel(
    label: 'Buy goods', 
    isTransaction: true,
    inputs: [
      OptionInput(label: 'Lipa na M-PESA', type: OptionInputType.fixed, value: '6'),
      OptionInput(label: 'Buy Goods and Services', type: OptionInputType.fixed, value: '2'),
      OptionInput(key: 'TillNo', label: 'Enter Till Number', type: OptionInputType.numberValue, minLength: 4, maxLength: 10),
      OptionInput.amount(),
      OptionInput.pin(),
    ]
  ),

  // Airtime
  OptionModel(
    label: 'Airtime', 
    inputs: [
      OptionInput(label: 'Buy Airtime', type: OptionInputType.fixed, value: '3'),
      OptionInput(label: 'Buy Airtime', type: OptionInputType.fixed, value: '1'),
    ],
    options: [
      // my number
      OptionModel(
        label: 'My Phone',
        inputs: [
          OptionInput(label: 'My Phone', type: OptionInputType.fixed, value: '1'),
          OptionInput.amount(),
          OptionInput.pin(),
        ]
      ),

      // other number
      OptionModel(
        label: 'Other Phone',
        isTransaction: true,
        inputs: [
          OptionInput(key: 'PhoneNo', label: 'Other Phone', type: OptionInputType.fixed, value: '2'),
          OptionInput.phoneNumber(),
          OptionInput.amount(),
          OptionInput.pin(),
        ]
      ),
    ],
  ),


  // Savings & Loans
  OptionModel(
    label: 'Loans & Savings', 
    inputs: [],
    options: [
      // M-Shwari
      OptionModel(
        label: 'M-Shwari',
        inputs: [
          OptionInput(label: 'Loans & Savings', type: OptionInputType.fixed, value: '4'),
          OptionInput(label: 'M-Shwari', type: OptionInputType.fixed, value: '2'),
        ],
        options: [
          OptionModel(
            label: 'Send to M-Shwari', 
            inputs: [
              OptionInput(label: 'Send to M-Shwari', type: OptionInputType.fixed, value: '1'),
              OptionInput.amount(),
              OptionInput(label: 'Accept', type: OptionInputType.fixed, value: '1'),
              OptionInput.pin(),
            ]
          ),
          OptionModel(
            label: 'Withdraw form M-Shwari', 
            inputs: [
              OptionInput(label: 'Withdraw form M-Shwari', type: OptionInputType.fixed, value: '2'),
              OptionInput.amount(),
              OptionInput(label: 'Accept', type: OptionInputType.fixed, value: '1'),
              OptionInput.pin(),
            ]
          ),
          OptionModel(
            label: 'Loans', 
            inputs: [
              OptionInput(label: 'Loans', type: OptionInputType.fixed, value: '3'),
            ],
            options: [
              OptionModel(
                label: 'Request Loan', 
                inputs: [
                  OptionInput(label: 'Request Loan', type: OptionInputType.fixed, value: '1'),
                  OptionInput.amount(),
                  OptionInput.pin(),
                ]
              ),
              OptionModel(
                label: 'Pay Loan', 
                inputs: [
                  OptionInput(label: 'Pay Loan', type: OptionInputType.fixed, value: '2'),
                ],
                options: [
                  OptionModel(
                    label: 'From M-PESA', 
                    inputs: [
                      OptionInput(label: 'From M-PESA', type: OptionInputType.fixed, value: '1'),
                      OptionInput.amount(),
                      OptionInput.pin(),
                    ]
                  ),
                  OptionModel(
                    label: 'From M-Shwari', 
                    inputs: [
                      OptionInput(label: 'From M-Shwari', type: OptionInputType.fixed, value: '2'),
                      OptionInput.amount(),
                      OptionInput.pin(),
                    ]
                  ),

                ]
              ),
              OptionModel(
                label: 'Check limit', 
                inputs: [
                  OptionInput(label: 'Check limit', type: OptionInputType.fixed, value: '3'),
                  OptionInput.pin(),
                ]
              ),
              OptionModel(
                label: 'Loan Balance', 
                inputs: [
                  OptionInput(label: 'Loan Balance', type: OptionInputType.fixed, value: '4'),
                  OptionInput.pin(),
                ]
              ),
            ]
          ),
          OptionModel(
            label: 'Check Balance', 
            inputs: [
              OptionInput(label: 'Check Balance', type: OptionInputType.fixed, value: '4'),
              OptionInput.pin(),
            ]
          ),
          OptionModel(
            label: 'Mini Statement', 
            inputs: [],
            options: [
              OptionModel(
                label: 'Loan Statement', 
                inputs: [
                  OptionInput(label: 'Mini Statement', type: OptionInputType.fixed, value: '5'),
                  OptionInput(label: 'Loan', type: OptionInputType.fixed, value: '1'),
                  OptionInput.pin(),
                ]
              ),
              OptionModel(
                label: 'Deposit Account Statement', 
                inputs: [
                  OptionInput(label: 'Mini Statement', type: OptionInputType.fixed, value: '5'),
                  OptionInput(label: 'Loan', type: OptionInputType.fixed, value: '2'),
                  OptionInput.pin(),
                ]
              )
            ]
          ),
        ]
      ),

      // KCB M-PESA
      OptionModel(
        label: 'KCB M-PESA',
        inputs: [
          OptionInput(label: 'Loans & Savings', type: OptionInputType.fixed, value: '4'),
          OptionInput(label: 'KCB M-PESA', type: OptionInputType.fixed, value: '3'),
        ],
        options: [
          OptionModel(
            label: 'Deposit from M-PESA', 
            inputs: [
              OptionInput(label: 'Deposit from M-PESA', type: OptionInputType.fixed, value: '1'),
              OptionInput.amount(),
              OptionInput(label: 'Accept', type: OptionInputType.fixed, value: '1'),
              OptionInput.pin(),
            ]
          ),
          OptionModel(
            label: 'Withdraw to M-PESA', 
            inputs: [
              OptionInput(label: 'Withdraw to M-PESA', type: OptionInputType.fixed, value: '2'),
              OptionInput.amount(),
              OptionInput(label: 'Accept', type: OptionInputType.fixed, value: '1'),
              OptionInput.pin(),
            ]
          ),
          OptionModel(
            label: 'Loans', 
            inputs: [
              OptionInput(label: 'Loans', type: OptionInputType.fixed, value: '3'),
            ],
            options: [
              OptionModel(
                label: 'Request Loan', 
                inputs: [
                  OptionInput(label: 'Request Loan', type: OptionInputType.fixed, value: '1'),
                  OptionInput.amount(),
                  OptionInput(label: 'Accept', type: OptionInputType.fixed, value: '1'),
                  OptionInput.pin(),
                ]
              ),
              OptionModel(
                label: 'Pay Loan', 
                inputs: [
                  OptionInput(label: 'Pay Loan', type: OptionInputType.fixed, value: '2'),
                  OptionInput(label: 'From M-PESA', type: OptionInputType.fixed, value: '1'),
                  OptionInput.amount(),
                  OptionInput(label: 'Accept', type: OptionInputType.fixed, value: '1'),
                  OptionInput.pin(),
                ],
                
              ),
              OptionModel(
                label: 'Check limit', 
                inputs: [
                  OptionInput(label: 'Check limit', type: OptionInputType.fixed, value: '3'),
                  OptionInput.pin(),
                ]
              ),
              OptionModel(
                label: 'Loan Balance', 
                inputs: [
                  OptionInput(label: 'Loan Balance', type: OptionInputType.fixed, value: '4'),
                  OptionInput.pin(),
                ]
              ),
            ]
          ),
          OptionModel(
            label: 'Check Balance', 
            inputs: [
              OptionInput(label: 'Check Balance', type: OptionInputType.fixed, value: '4'),
              OptionInput(label: 'Check Balance', type: OptionInputType.fixed, value: '1'),
              OptionInput.pin(),
            ]
          ),
          OptionModel(
            label: 'Mini Statement', 
            inputs: [],
            options: [
              OptionModel(
                label: 'Loan Statement', 
                inputs: [
                  OptionInput(label: 'Mini Statement', type: OptionInputType.fixed, value: '4'),
                  OptionInput(label: 'Loan', type: OptionInputType.fixed, value: '1'),
                  OptionInput.pin(),
                ]
              ),
              OptionModel(
                label: 'Deposit Account Statement', 
                inputs: [
                  OptionInput(label: 'Mini Statement', type: OptionInputType.fixed, value: '5'),
                  OptionInput(label: 'Loan', type: OptionInputType.fixed, value: '2'),
                  OptionInput.pin(),
                ]
              )
            ]
          ),
        ]
      ),
      
    ],
  ),
];

List<OptionModel> get services {
  var shared = OptionModel(
    label: 'Pay Bill', 
    isTransaction: true,
    isService: true,
    inputs: [
      OptionInput(label: 'Lipa na M-PESA', type: OptionInputType.fixed, value: '6'),
      OptionInput(label: 'Pay Bill', type: OptionInputType.fixed, value: '1'),
      OptionInput(key: 'BusinessNo', label: 'Enter Business Number', type: OptionInputType.numberValue, minLength: 0, maxLength: 20),
      OptionInput(key: 'AccountNo', label: 'Enter Account Number', type: OptionInputType.value, minLength: 0, maxLength: 20),
      OptionInput.amount(),
      OptionInput.pin(),
    ]
  );

  var equity = OptionModel.fromAnother(shared, label: 'EQUITY', options: [], inputs: []);
  equity.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '247247');

  var coop1 = OptionModel.fromAnother(shared, label: 'CO-OP free', options: [], inputs: []);
  coop1.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '400200');

  var coop2 = OptionModel.fromAnother(shared, label: 'CO-OP', options: [], inputs: []);
  coop2.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '400222');

  var kcb = OptionModel.fromAnother(shared, label: 'KCB', options: [], inputs: []);
  kcb.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '522522');

  var family = OptionModel.fromAnother(shared, label: 'Family', options: [], inputs: []);
  family.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '222111');

  var kplcTokens = OptionModel.fromAnother(shared, label: 'Token', options: [], inputs: []);
  kplcTokens.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '888880');

  var kplcPost = OptionModel.fromAnother(shared, label: 'Post Pay', options: [], inputs: []);
  kplcPost.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '888888');

  var nhif = OptionModel.fromAnother(shared, label: 'NHIF', options: [], inputs: []);
  nhif.inputs[2] = OptionInput(label: 'Enter Business Number', type: OptionInputType.fixed, value: '200222');

  return [
    // bank
    OptionModel(
      label: 'Banks',
      inputs: [],
      options: [
        // equity
        equity,

        // coop
        OptionModel(label: 'CO-OP', inputs: [], options: [coop1, coop2]),

        // kcb
        kcb,

        // family
        family,
      ]
    ),

    // kplc
    OptionModel(
      label: 'KPLC', 
      inputs: [],
      options: [
        // tokens
        kplcTokens,

        // post pay
        kplcPost
      ]
    ),

    // nhif
    nhif,
  ];
}