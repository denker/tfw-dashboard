function getToday() {
    var today = new Date();
    if (today.getHours() < 16) {
        today.setDate(today.getDate()-1)
    }
    today.setHours(0, 0, 0, 0);
    return today;
}

function getRecordDate(string) {
    var dateArray = string.split('/');
    var recordDate = new Date(dateArray[2], dateArray[0] - 1, dateArray[1]);
    //console.log(recordDate);
    return recordDate;
}

function sumUpRows(rows) {
    var data = {
        "checks": 0,
            "guests": 0,
            "total": 0
    };
    for (i = 0; i < rows.length; i++) {
        data.checks += 1;
        data.guests += Number(rows[i].male) + Number(rows[i].female);
        data.total += Number(rows[i].total);
    }
    return data;
}

function callback(data) {
    var today = getToday();
    var rows = [];
    var cells = data.feed.entry;
    for (var i = 0; i < cells.length; i++) {
        var rowObj = {};
        rowObj.date = cells[i].title.$t;
        if (today.valueOf() == getRecordDate(rowObj.date).valueOf()) {
            var rowData = cells[i].content.$t.split(', ');
            rowObj.male = rowData[2].split(': ')[1].trim();
            rowObj.female = rowData[3].split(': ')[1].trim();
            rowObj.total = rowData[4].split(': ')[1];
            rows.push(rowObj);
        }
    }
    var output = sumUpRows(rows);
    console.log(today);
    $("#date").text(today.getDate() + '.' + (today.getMonth()+1));
    $("#checks").text(output.checks);
    $("#guests").text(output.guests);
    $("#total").text(output.total);
}

$.ajax({
    url: 'https://spreadsheets.google.com/feeds/list/1CcahuP3LF9MPIru91g5IPQfSbCa6FphaLjWqiYF_wNw/1/public/basic?alt=json',
    success: function (data) {
		callback(data);
    }
});
