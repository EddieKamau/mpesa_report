DateTime? extractDate(String _body){
  DateTime _dateTime;
  String _dtRaw;
  if(!_body.contains(' on ')){
    return null;
  }
    if(_body.contains('transaction')){
       if(_body.contains('  on ')){
        _dtRaw = _body.split('  on ')[1];
      }else{
        _dtRaw = _body.split(' on ')[1];
      }

      
    } else if(_body.contains('.on ')){
      _dtRaw = _body.split('.on ')[1];
    }else{
      _dtRaw = _body.split(' on ')[1];
    }
    
  List _date;
  List _time;
  String _period;
  if(_dtRaw.contains('  at ')){
    _date = _dtRaw.split('  at ')[0].split('/');
    _time = _dtRaw.split('  at ')[1].split(' ')[0].split(':');
    _period = _dtRaw.split('  at ')[1].split(' ')[1].substring(0, 2);
  }
  else if(_dtRaw.contains(' at ')){
    _date = _dtRaw.split(' at ')[0].split('/');
    _time = _dtRaw.split(' at ')[1].split(' ')[0].split(':');
    _period = _dtRaw.split(' at ')[1].split(' ')[1].substring(0, 2);
  } else{
    _date = _dtRaw.split(' ')[0].split('/');
    _time = _dtRaw.split(' ')[1].split(':');
    _period = _dtRaw.split(' ')[2];
  }
  _dateTime = DateTime(
    int.parse('20${_date[2]}'), // year
    int.parse(_date[1]), // month
    int.parse(_date[0]), // day
    _period.contains('PM') ? int.parse(_time[0]) < 12 ? int.parse('${12 + int.parse(_time[0])}') : int.parse(_time[0]): int.parse(_time[0]), // hour
    int.parse(_time[1]), // minute
  );

  return _dateTime;
}